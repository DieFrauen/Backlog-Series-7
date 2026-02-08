--Encroaching Shadows
function c26073011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetDescription(aux.Stringid(26073011,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(1,26073011,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c26073011.rvtg)
	e1:SetOperation(c26073011.rvop)
	c:RegisterEffect(e1)
	--activate effect from graveyard
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26073011,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetHintTiming(TIMING_MAIN_END,TIMING_MAIN_END|TIMING_BATTLE_START|TIMING_BATTLE_END)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c26073011.con)
	e2:SetCost(Cost.SelfBanish)
	e2:SetTarget(c26073011.tg)
	e2:SetOperation(c26073011.op)
	c:RegisterEffect(e2)
end
function c26073011.rvfilter(c)
	return c:IsSetCard(0x673) and c:IsAbleToHand() and not c:IsPublic()
end
function c26073011.rvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26073011.rvfilter,tp,LOCATION_DECK,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SET,nil,0,tp,1)
end
function c26073011.rvop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c26073011.rvfilter,tp,LOCATION_DECK,0,3,3,nil)
	if #g~=3 then return end
	Duel.ConfirmCards(1-tp,g)
	local tc=g:RandomSelect(1-tp,1):GetFirst()
	Duel.ShuffleDeck(tp)
	if tc then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		Duel.ShuffleHand(tp)
		if c26073011.setop(tc,e,tp,0) then
			c26073011.setop(tc,e,tp,1)
		end
	end
end
function c26073011.con(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) and (Duel.IsMainPhase() or Duel.IsBattlePhase()) 
end
function c26073011.filter(c)
	return c:IsSetCard(0x673) and not c:IsPublic()
end
function c26073011.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26073011.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetPossibleOperationInfo(0,CATEGORY_SET,nil,0,tp,1)
end
function c26073011.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,c26073011.filter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	if tc and c26073011.setop(tc,e,tp,0) then
		Duel.ConfirmCards(1-tp,tc)
		Duel.ShuffleHand(tp)
		c26073011.setop(tc,e,tp,1)
	end
end
function c26073011.setop(tc,e,tp,chk)
	local b1,b2,sc=tc:IsMonster(),tc:IsSpellTrap(),nil
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if chk==0 then return (b1 or b2) end
	if (b1 and b2) or not b2 then
		sc=hg:FilterSelect(tp,Card.IsMSetable,1,1,nil,true,nil):GetFirst()Duel.MSet(tp,sc,true,nil)
	else
		sc=hg:FilterSelect(tp,Card.IsSSetable,1,1,nil):GetFirst() 
		Duel.SSet(tp,sc,tp,false)
	end
end