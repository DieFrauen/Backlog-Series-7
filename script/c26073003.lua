--Polterghast Althos
function c26073003.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26073003,0))
	e1:SetCategory(CATEGORY_HANDES|CATEGORY_RELEASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET|EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_FLIP|EFFECT_TYPE_TRIGGER_O)
	e1:SetTarget(c26073003.fltg)
	e1:SetOperation(c26073003.flop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26073003,2))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,26073003)
	e2:SetTarget(c26073003.tgtg)
	e2:SetOperation(c26073003.tgop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e3)
	--indestructible (including as material)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(26073003)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	c:RegisterEffect(e4)
	aux.GlobalCheck(c26073003,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		ge1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		ge1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		ge1:SetTarget(function(e,c)
			local cp=c:GetControler()
			return c:IsFacedown() and
			(Duel.IsPlayerAffectedByEffect(cp,26073003)
			or Duel.IsExistingMatchingCard(c26073003.indfilter,cp,LOCATION_MZONE,0,1,nil)) end)
		ge1:SetValue(1)
		Duel.RegisterEffect(ge1,0)
	end)
end
function c26073003.indfilter(c)
	return c:IsFacedown() and c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,26073003)
end
function c26073003.fltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToDeck()
	and c:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local b1=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_GRAVE)
end
function c26073003.flop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local p=tp
	if not Duel.IsPlayerAffectedByEffect(tp,26073014) then p=1-tp end
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,LOCATION_GRAVE)
	if tc and tc:IsRelateToEffect(e)
	and (#g==0 or Duel.SelectYesNo(p,aux.Stringid(26073003,1))) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		return
	end
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,2,nil)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end
function c26073003.tgfilter(c)
	return c:IsSetCard(0x673) and c:IsMonster() and c:IsAbleToGrave()
end
function c26073003.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26073003.tgfilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c26073003.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK|LOCATION_HAND)
end
function c26073003.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c26073003.tgfilter,tp,LOCATION_HAND,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c26073003.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	g:Merge(g2)
	if #g>1 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end