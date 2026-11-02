--Theriomachine Minos
function c26074002.initial_effect(c)
	--Gemini
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_GEMINI_SUMMONABLE)
	c:RegisterEffect(e0)
	local e0a=Effect.CreateEffect(c)
	e0a:SetType(EFFECT_TYPE_SINGLE)
	e0a:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0a:SetRange(LOCATION_MZONE)
	e0a:SetCode(EFFECT_ADD_TYPE)
	e0a:SetCondition(Gemini.NormalStatusCondition)
	e0a:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e0a)
	local e0b=e0a:Clone()
	e0b:SetCode(EFFECT_REMOVE_TYPE)
	e0b:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e0b)
	local e0c=e0a:Clone()
	e0c:SetValue(TYPE_TUNER)
	e0c:SetCondition(Gemini.EffectStatusCondition)
	c:RegisterEffect(e0c)
	--tribute from Deck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE|CATEGORY_RELEASE)
	e1:SetDescription(aux.Stringid(26074002,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	--e1:SetCountLimit(1,id)
	e1:SetCondition(Gemini.EffectStatusCondition)
	e1:SetTarget(c26074002.target1)
	e1:SetOperation(c26074002.operation1)
	c:RegisterEffect(e1)
	--tribute to revive
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26074002,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	--e2:SetCountLimit(1,id)
	e2:SetCondition(c26074002.condition2)
	e2:SetTarget(c26074002.target2)
	e2:SetOperation(c26074002.operation2)
	c:RegisterEffect(e2)
	--tribute to draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26074002,2))
	e3:SetCategory(CATEGORY_TOHAND|CATEGORY_RELEASE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_RELEASE)
	--e3:SetCountLimit(1,id)
	e3:SetTarget(c26074002.target3)
	e3:SetOperation(c26074002.operation3)
	c:RegisterEffect(e3)
end
function c26074002.tgfilter(c)
	return c:IsType(TYPE_GEMINI) and c:IsAbleToGrave()
end
function c26074002.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26074002.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_DECK)
end
function c26074002.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c26074002.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT|REASON_RELEASE)
	end
end
function c26074002.tfilter(c)
	return c:IsType(TYPE_GEMINI) and c:IsFaceup()
end
function c26074002.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26074002.tfilter,1,nil) 
	and not eg:IsContains(e:GetHandler())
	and Gemini.EffectStatusCondition(e)
end
function c26074002.filter2(c,e,tp)
	return c:IsType(TYPE_GEMINI)
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)	
	and Duel.CheckReleaseGroupEx(tp,c26074002.refilter,1,nil,c)
end
function c26074002.refilter(c,tc)
	return c:IsType(TYPE_GEMINI) and c:IsLocation(LOCATION_HAND) and not c:IsCode(tc:GetCode())
end
function c26074002.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c26074002.filter2(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c26074002.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c26074002.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c26074002.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local g=Duel.SelectReleaseGroupEx(tp,c26074002.refilter,1,1,nil,tc)
	if g and #g>0 then
		Duel.HintSelection(g)
		if Duel.Release(g,REASON_EFFECT)~=nil
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and tc:IsType(TYPE_GEMINI) 
		and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c26074002.gfilter(c,tp)
	return c:IsSummonable(true,nil)
	and c:IsType(TYPE_GEMINI)
	and (c:IsOnField() or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
end
function c26074002.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26074002.gfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c26074002.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c26074002.gfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end