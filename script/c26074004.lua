--Theriomachine Harpy
function c26074004.initial_effect(c)
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
	--fetch spell/trap
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND|CATEGORY_LEAVE_GRAVE)
	e1:SetDescription(aux.Stringid(26074004,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY|EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(Gemini.EffectStatusCondition)
	e1:SetTarget(c26074004.target1)
	e1:SetOperation(c26074004.operation1)
	c:RegisterEffect(e1)
	--Return Spell/Trap from field to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26074004,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY|EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c26074004.condition2)
	e2:SetTarget(c26074004.target2)
	e2:SetOperation(c26074004.operation2)
	c:RegisterEffect(e2)
	--search monster
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26074004,2))
	e3:SetCategory(CATEGORY_TOHAND|CATEGORY_RELEASE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_RELEASE)
	e3:SetCountLimit(1,26074004)
	e3:SetTarget(c26074004.target3)
	e3:SetOperation(c26074004.operation3)
	c:RegisterEffect(e3)
end
function c26074004.thfilter(c)
	return c:IsAbleToHand()
	and (c:IsSpell() and c:IsSetCard(0x674) or c:IsTrap())
end
function c26074004.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c26074004.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectTarget(tp,c26074004.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,0)
end
function c26074004.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c26074004.thfilter(tc) then
		Duel.SSet(tp,tc)
	end
end
function c26074004.tfilter(c)
	return c:IsType(TYPE_GEMINI) and c:IsFaceup()
end
function c26074004.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26074004.tfilter,1,nil) 
	and not eg:IsContains(e:GetHandler())
	and Gemini.EffectStatusCondition(e)
end
function c26074004.filter2(c,e,tp)
	return c:IsType(TYPE_GEMINI) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26074004.lvfilter(c)
	return c:IsLevelAbove(1) and c:IsFaceup()
end
function c26074004.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c26074004.lvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
end
function c26074004.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,tc:GetControler(),REASON_EFFECT)
	end
end
function c26074004.filter3(c)
	return c:IsSetCard(0x674) and c:IsMonster() and c:IsAbleToHand()
end
function c26074004.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26074004.filter3,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26074004.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26074004.filter3,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT|REASON_DISCARD,nil)
	end
end