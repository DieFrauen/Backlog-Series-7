--Polterghast - Pollutia
function c26073005.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26073005,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET|EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O|EFFECT_TYPE_FLIP)
	e1:SetTarget(c26073005.fltg)
	e1:SetOperation(c26073005.flop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26073005,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET|EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,26073005)
	e2:SetTarget(c26073005.sptg)
	e2:SetOperation(c26073005.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e3)
	--cannot negate (including as material)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(26073005)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	c:RegisterEffect(e4)
	aux.GlobalCheck(c26073005,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		ge1:SetCode(EFFECT_CANNOT_INACTIVATE)
		ge1:SetValue(function(e,ct)
			local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
			local tc=te:GetHandler()
			return te:IsMonsterEffect() and
			te:GetType()&TYPE_FLIP ==TYPE_FLIP and
			(Duel.IsPlayerAffectedByEffect(cp,26073005)
			or Duel.IsExistingMatchingCard(c26073005.ungfilter,cp,LOCATION_MZONE,0,1,nil)) end)
		Duel.RegisterEffect(ge1,0)
	end)
end
function c26073005.ungfilter(c)
	return c:IsFacedown() and c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,26073005)
end
function c26073005.rmfilter(c)
	return c:IsAbleToRemove() and aux.SpElimFilter(c)
end
function c26073005.fltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToRemove()
	and c:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	local dc=math.min(4,Duel.GetFieldGroupCount(tp,0,LOCATION_DECK))
	local g1=Duel.GetDecktopGroup(1-tp,dc):Filter(Card.IsAbleToRemove,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,g1,dc-1,0,0)
end
function c26073005.flop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetDecktopGroup(1-tp,math.min(4,Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)))
	Duel.ConfirmDecktop(1-tp,#g)
	local p=tp
	if not Duel.IsPlayerAffectedByEffect(tp,26073014) then p=1-tp end
	if tc and tc:IsRelateToEffect(e) and Duel.SelectYesNo(p,aux.Stringid(26073005,1)) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		return
	end
	local tg=g:Select(tp,1,3,nil)
	Duel.DisableShuffleCheck()
	if #tg>0 then
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	end
end
function c26073005.spfilter(c,e,tp)
	return c:IsType(TYPE_FLIP) and c:IsLevelBelow(2)
	and not c:IsCode(26073005) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26073005.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c26073005.spfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26073005.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c26073005.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,#g,0,0)
end
function c26073005.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,tc)
	end
end