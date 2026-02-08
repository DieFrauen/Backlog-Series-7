--Polterghast Subconscious
function c26073014.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Special Summon 1 "Polterghast" monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26073014,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,26073014)
	e1:SetTarget(c26073014.ovtg)
	e1:SetOperation(c26073014.ovop)
	e1:SetHintTiming(0,TIMING_BATTLE_STEP_END|TIMINGS_CHECK_MONSTER)
	c:RegisterEffect(e1)
	--Change 1 monster Defense Position
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26073014,1))
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_SET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMING_STANDBY_PHASE|TIMING_MAIN_END|TIMINGS_CHECK_MONSTER_E)
	e2:SetCountLimit(1,26073014)
	e2:SetTarget(c26073014.postg)
	e2:SetOperation(c26073014.posop)
	c:RegisterEffect(e2)
	--set all face-down
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26073014,2))
	e3:SetCategory(CATEGORY_POSITION+CATEGORY_TODECK+CATEGORY_SET)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,26073014)
	e3:SetCost(c26073014.setcost)
	e3:SetTarget(c26073014.settg)
	e3:SetOperation(c26073014.setop)
	c:RegisterEffect(e3)
	--choose battle target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_PATRICIAN_OF_DARKNESS)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	e4:SetCondition(c26073014.condition)
	c:RegisterEffect(e4)
	--Subconscious (condition FLIP effects)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(26073014)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(1,0)
	c:RegisterEffect(e5)
end
c26073014.listed_series={0x673}
--battle target selection
function c26073014.condition(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,0,1,nil)
end
function c26073014.xyzfilter(c,tp)
	return c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c26073014.matfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,c)
end
function c26073014.matfilter(c)
	return c:IsSetCard(0x673) and c:IsMonster() 
end
function c26073014.ovtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c26073014.xyzfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c26073014.xyzfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectTarget(tp,c26073014.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	if not tc:IsFaceup() and tc:GetOverlayCount()==0 then
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c26073014.ovop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c26073014.matfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil)
		if not tc:IsFaceup() and tc:GetOverlayCount()==0 then
			Duel.ConfirmCards(1-tp,tc)
		end
		if #g>0 then
			Duel.Overlay(tc,g,true)
		end
	end
end
function c26073014.filter2(c)
	return c:IsCanTurnSet() or c:IsFacedown() or c:IsCanChangePosition()
end
function c26073014.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c26073014.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26073014.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c26073014.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,tp,POS_FACEUP_DEFENSE|POS_FACEDOWN_DEFENSE)
end
function c26073014.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:IsAttackPos() then
			local pos=0
			if tc:IsCanTurnSet() then
				pos=Duel.SelectPosition(tp,tc,POS_DEFENSE)
			else
				pos=Duel.SelectPosition(tp,tc,POS_FACEUP_DEFENSE)
			end
			Duel.ChangePosition(tc,pos)
		else
			Duel.ChangePosition(tc,0,0,POS_FACEDOWN_DEFENSE,POS_FACEUP_DEFENSE)
		end
	end
end
function c26073014.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsStatus(STATUS_EFFECT_ENABLED) end
	Duel.SendtoGrave(c,REASON_COST)
end
function c26073014.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,tp,POS_FACEDOWN_DEFENSE)
	local tg=Duel.GetMatchingGroup(aux.NOT(Card.IsCanTurnSet),tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #tg>0 then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tg,#tg,0,0)
	end
end
function c26073014.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g>0 and Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)>0 then
		local turn_p=Duel.GetTurnPlayer()
		local g1=Duel.GetMatchingGroup(Card.IsFaceup,turn_p,LOCATION_MZONE,0,nil)
		local g2=Duel.GetMatchingGroup(Card.IsFaceup,turn_p,0,LOCATION_MZONE,nil)
		if #g1==0 and #g2==0 then return end
		Duel.BreakEffect()
		if #g1>0 then
			Duel.SendtoDeck(g1,2,PLAYER_NONE,REASON_RULE,turn_p)
		end
		if #g2>0 then
			Duel.SendtoDeck(g2,2,PLAYER_NONE,REASON_RULE,1-turn_p)
		end
	end
end