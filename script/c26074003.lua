--Theriomachine Siren
function c26074003.initial_effect(c)
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
	--chain summoning
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetDescription(aux.Stringid(26074003,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	--e1:SetCountLimit(1,id)
	e1:SetCondition(Gemini.EffectStatusCondition)
	e1:SetTarget(c26074003.target1)
	e1:SetOperation(c26074003.operation1)
	c:RegisterEffect(e1)
	--level mod
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26074003,1))
	e2:SetCategory(CATEGORY_LVCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY|EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	--e2:SetCountLimit(1,id)
	e2:SetCondition(c26074003.condition2)
	e2:SetTarget(c26074003.target2)
	e2:SetOperation(c26074003.operation2)
	c:RegisterEffect(e2)
	local e2a=e2:Clone()
	e2a:SetCondition(c26074003.condition22)
	e2a:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2a)
	--tribute to draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26074003,2))
	e3:SetCategory(CATEGORY_TOHAND|CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_RELEASE)
	e3:SetCountLimit(1,26074003)
	e3:SetTarget(c26074003.target3)
	e3:SetOperation(c26074003.operation3)
	c:RegisterEffect(e3)
end
function c26074003.thfilter(c)
	return c:IsType(TYPE_GEMINI) and c:IsAbleToHand()
	and c:IsReason(REASON_RELEASE)
end
function c26074003.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26074003.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c26074003.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26074003.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
	end
end
function c26074003.tfilter(c)
	return c:IsType(TYPE_GEMINI) and c:IsFaceup()
end
function c26074003.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26074003.tfilter,1,nil) 
	and not eg:IsContains(e:GetHandler())
	and Gemini.EffectStatusCondition(e)
end
function c26074003.condition22(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_SYNCHRO) 
	and c26074003.condition2(e,tp,eg,ep,ev,re,r,rp)
end
function c26074003.filter2(c,e,tp)
	return c:IsType(TYPE_GEMINI) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26074003.lvfilter(c)
	return c:IsLevelAbove(1) and c:IsFaceup()
end
function c26074003.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c26074003.lvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26074003.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c26074003.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c26074003.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local op=0
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if tc:GetLevel()==1 then op=Duel.SelectOption(tp,aux.Stringid(26074003,3))
		else op=Duel.SelectOption(tp,aux.Stringid(26074003,3),aux.Stringid(26074003,4)) end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		if op==0 then
			e1:SetValue(1)
		else e1:SetValue(-1) end
		tc:RegisterEffect(e1)
	end
end
function c26074003.filter3(c)
	return c:IsSetCard(0x674) and c:IsSpellTrap() and c:IsAbleToHand()
end
function c26074003.tribute(c,p)
	return Duel.IsPlayerCanRelease(p,c)
end
function c26074003.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26074003.filter3,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26074003.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26074003.filter3,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Filter(c26074003.tribute,nil,tp):Select(tp,1,1,nil)  
		if #g>0 then Duel.SendtoGrave(g,REASON_EFFECT|REASON_RELEASE) end
	end
end