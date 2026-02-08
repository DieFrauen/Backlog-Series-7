--Polterghast - Cirros
function c26073002.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26073002,0))
	e1:SetCategory(CATEGORY_HANDES|CATEGORY_RELEASE|CATEGORY_SPECIAL_SUMMON|CATEGORY_SET)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET|EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O|EFFECT_TYPE_FLIP)
	e1:SetTarget(c26073002.fltg)
	e1:SetOperation(c26073002.flop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26073002,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,26073002)
	e2:SetTarget(c26073002.thtg)
	e2:SetOperation(c26073002.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e3)
	--untargetable (including as material)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(26073002)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	c:RegisterEffect(e4)
	aux.GlobalCheck(c26073002,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c26073002.actop)
		Duel.RegisterEffect(ge1,0)
	end)
end
function c26073002.actop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local cp=rc:GetControler()
	if (re:IsHasType(EFFECT_TYPE_FLIP) or rc:IsSetCard(0x673)) and
	(Duel.IsPlayerAffectedByEffect(cp,26073002) or 
	Duel.IsExistingMatchingCard(c26073002.untfilter,cp,LOCATION_MZONE,0,1,nil)) then
		Duel.SetChainLimit(c26073002.chainlm)
	end
end
function c26073002.chainlm(e,rp,tp)
	return tp==rp or e:GetActivateLocation()~=LOCATION_HAND
end
function c26073002.untfilter(c)
	return c:IsFacedown() and c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,26073002)
end
function c26073002.fltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsReleasableByEffect()
	and c:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsReleasableByEffect,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTarget(tp,Card.IsReleasableByEffect,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetPossibleOperationInfo(0,CATEGORY_RELEASE,g,#g,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,1-tp,LOCATION_HAND)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SET,nil,0,1-tp,LOCATION_HAND)
end
function c26073002.flop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local p=tp
	if not Duel.IsPlayerAffectedByEffect(tp,26073014) then p=1-tp end
	if tc and tc:IsRelateToEffect(e) and Duel.SelectYesNo(p,aux.Stringid(26073002,1)) then
		Duel.Release(tc,REASON_EFFECT)
		return
	end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if #g>0 then
		Duel.ConfirmCards(tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local sc=g:Select(tp,1,1,nil):GetFirst()
		local b1=--sc:IsMSetable(true,nil) or 
			sc:IsCanBeSpecialSummoned(e,0,1-tp,false,false,POS_FACEUP_ATTACK+POS_DEFENSE)
		local b2=sc:IsSSetable()
		local b3=sc:IsDiscardable()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26073002,2))
		local op=Duel.SelectEffect(p,
			{b1,aux.Stringid(26073002,3)},
			{b2,aux.Stringid(26073002,4)},
			{b3,aux.Stringid(26073002,5)})
		if op==1 then
			Duel.BreakEffect()
			--Duel.MSet(1-tp,sc,true,e)
			Duel.SpecialSummon(sc,0,1-tp,1-tp,false,false,POS_FACEUP_ATTACK+POS_DEFENSE)
		end
		if op==2 then
			Duel.SSet(1-tp,sc,1-tp,false)
		end
		if op==3 then
			Duel.SendtoGrave(sc,REASON_EFFECT|REASON_DISCARD)
		end
		Duel.ShuffleHand(1-tp)
	end
end
function c26073002.thfilter(c)
	return c:IsSetCard(0x673) and c:IsMonster() and c:IsAbleToHand()
end
function c26073002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26073002.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26073002.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26073002.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end