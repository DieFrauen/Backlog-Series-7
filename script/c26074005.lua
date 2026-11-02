--Theriomachine Imp
function c26074005.initial_effect(c)
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
	--Summon from Deck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(26074005,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	--e1:SetCountLimit(1,id)
	e1:SetCondition(Gemini.EffectStatusCondition)
	e1:SetTarget(c26074005.target1)
	e1:SetOperation(c26074005.operation1)
	c:RegisterEffect(e1)
	--Damage + Raise ATK
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26074005,1))
	e2:SetCategory(CATEGORY_ATKCHANGE|CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY|EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	--e2:SetCountLimit(1,id)
	e2:SetCondition(c26074005.condition2)
	e2:SetTarget(c26074005.target2)
	e2:SetOperation(c26074005.operation2)
	c:RegisterEffect(e2)
	local e2a=e2:Clone()
	e2a:SetCondition(c26074005.condition22)
	e2a:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2a)
	--tribute to draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26074005,2))
	e3:SetCategory(CATEGORY_LVCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_RELEASE)
	--e3:SetCountLimit(1,id)
	e3:SetTarget(c26074005.target3)
	e3:SetOperation(c26074005.operation3)
	c:RegisterEffect(e3)
end
function c26074005.spfilter(c,e,tp)
	return c:IsSetCard(0x674) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26074005.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c26074005.spfilter,tp,LOCATION_HAND|LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND|LOCATION_DECK)
end
function c26074005.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c26074005.spfilter,tp,LOCATION_HAND|LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c26074005.tfilter(c)
	return c:IsType(TYPE_GEMINI) and c:IsFaceup()
end
function c26074005.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26074005.tfilter,1,nil) 
	and not eg:IsContains(e:GetHandler())
	and Gemini.EffectStatusCondition(e)
end
function c26074005.condition22(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_SYNCHRO) 
	and c26074005.condition2(e,tp,eg,ep,ev,re,r,rp)
end
function c26074005.filter2(c,e,tp)
	return c:IsType(TYPE_GEMINI) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26074005.lvfilter(c,g)
	return c:IsLevelAbove(1) and c:IsFaceup() and g:IsContains(c)
end
function c26074005.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c26074005.lvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26074005.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,eg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c26074005.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,eg)
end
function c26074005.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local lv=tc:GetLevel()*100
		Duel.Damage(1-tp,lv,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		e1:SetValue(lv)
		tc:RegisterEffect(e1)
	end
end
function c26074005.filter3(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function c26074005.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c26074005.filter3(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26074005.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectTarget(tp,c26074005.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
	local lv=Duel.AnnounceLevel(tp,1,5,tc:GetLevel())
	Duel.SetTargetParam(lv)
end
function c26074005.operation3(e,tp,eg,ep,ev,re,r,rp)
	local g,lv=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS,CHAININFO_TARGET_PARAM)
	local tc=g:Filter(Card.IsRelateToEffect,nil,e):GetFirst()
	if #g>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end