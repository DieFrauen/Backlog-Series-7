--Polterghast - Turbulas
function c26073004.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26073004,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET|EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O|EFFECT_TYPE_FLIP)
	e1:SetTarget(c26073004.fltg)
	e1:SetOperation(c26073004.flop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26073004,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET|EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,26073004)
	e2:SetTarget(c26073004.thtg)
	e2:SetOperation(c26073004.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e3)
	--untargetable (including as material)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(26073004)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	c:RegisterEffect(e4)
	aux.GlobalCheck(c26073004,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		ge1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		ge1:SetTargetRange(LOCATION_GRAVE|LOCATION_SZONE,LOCATION_GRAVE|LOCATION_SZONE)
		ge1:SetTarget(function(e,c)
			local cp=c:GetControler()
			return c:IsSetCard(0x673) and c:IsFaceup() and e:GetHandlerPlayer()==cp and
			(Duel.IsPlayerAffectedByEffect(cp,26073004)
			or Duel.IsExistingMatchingCard(c26073004.untfilter,cp,LOCATION_MZONE,0,1,nil)) end)
		ge1:SetValue(aux.tgoval)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		Duel.RegisterEffect(ge2,1)
	end)
end
function c26073004.untfilter(c)
	return c:IsFacedown() and c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,26073004)
end
function c26073004.rmfilter(c,tp)
	return c:IsAbleToRemove(tp,POS_FACEDOWN,REASON_EFFECT) and aux.SpElimFilter(c)
end
function c26073004.fltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToRemove()
	and c:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil,tp,POS_FACEDOWN,REASON_EFFECT) end
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil,tp,POS_FACEDOWN,REASON_EFFECT)
	local g2=Duel.GetMatchingGroup(c26073004.rmfilter,tp,0,LOCATION_MZONE|LOCATION_GRAVE,nil,tp)
	local g3=Duel.GetDecktopGroup(1-tp,3):Filter(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil,tp,POS_FACEDOWN,REASON_EFFECT)
	Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,g1,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,g2,2,0,0)
	if g3==3 then
	Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,g3,3,0,0) end
end
function c26073004.flop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	local g2=Duel.GetMatchingGroup(c26073004.rmfilter,tp,0,LOCATION_MZONE|LOCATION_GRAVE,nil)
	local g3=Duel.GetDecktopGroup(1-tp,3)
	local b1=tc and tc:IsRelateToEffect(e) 
	local b2=g1:IsExists(Card.IsAbleToRemove,1,nil)
	local b3=g2:IsExists(Card.IsAbleToRemove,2,tc)
	local b4=g3:FilterCount(Card.IsAbleToRemove,nil)==3
	local p=tp
	if not Duel.IsPlayerAffectedByEffect(tp,26073014) then p=1-tp end
	Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(26073004,1))
	local sg=Group.CreateGroup()
	local op=Duel.SelectEffect(p,
		{b1,aux.Stringid(26073004,2)},
		{b2,aux.Stringid(26073004,3)},
		{b3,aux.Stringid(26073004,4)},
		{b4,aux.Stringid(26073004,5)})
	if op==1 then
		sg:AddCard(tc)
	elseif op==2 then
		sg=g1:Select(1-tp,1,1,nil)
	elseif op==3 then
		sg=g1:Select(1-tp,2,2,nil)
	elseif op==4 then
		sg=g3:Clone()
	end
	Duel.HintSelection(sg)
	Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
end
function c26073004.filter(c)
	return c:IsSetCard(0x673) and c:IsAbleToHand()
end
function c26073004.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c26073004.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26073004.filter,tp,LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c26073004.filter,tp,LOCATION_GRAVE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c26073004.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT|REASON_DISCARD)
	end
end