--Eye of the Polterghast
function c26073015.initial_effect(c)
	--Set Monster face-down
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26073015,0))
	e1:SetCategory(CATEGORY_POSITION|CATEGORY_SET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(0x1)
	e1:SetTarget(c26073015.target1)
	e1:SetOperation(c26073015.activate1)
	e1:SetHintTiming(TIMING_END_PHASE,TIMING_STANDBY_PHASE|TIMING_MAIN_END|TIMING_BATTLE_START|TIMING_BATTLE_PHASE|TIMINGS_CHECK_MONSTER_E)
	c:RegisterEffect(e1)
	--Set Monster face-down
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26073015,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetLabel(0x2)
	e2:SetTarget(c26073015.target2)
	e2:SetOperation(c26073015.activate2)
	e2:SetHintTiming(TIMING_END_PHASE,TIMING_STANDBY_PHASE|TIMING_MAIN_END|TIMING_BATTLE_START|TIMING_BATTLE_PHASE|TIMINGS_CHECK_MONSTER_E)
	c:RegisterEffect(e2)
	--flip Monster face-up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26073015,2))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetLabel(0x4)
	e3:SetTarget(c26073015.target3)
	e3:SetOperation(c26073015.activate3)
	e3:SetHintTiming(TIMING_END_PHASE,TIMING_STANDBY_PHASE|TIMING_MAIN_END|TIMING_BATTLE_START|TIMING_BATTLE_PHASE|TIMINGS_CHECK_MONSTER_E)
	c:RegisterEffect(e3)
	--Set Monster face-down
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26073015,3))
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetLabel(3)
	e4:SetTarget(c26073015.target)
	e4:SetOperation(c26073015.activate)
	e4:SetHintTiming(TIMING_END_PHASE,TIMING_STANDBY_PHASE|TIMING_MAIN_END|TIMING_BATTLE_START|TIMING_BATTLE_PHASE|TIMINGS_CHECK_MONSTER_E)
	c:RegisterEffect(e4)
end
function c26073015.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanTurnSet() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,tp,POS_FACEDOWN_DEFENSE)
end
function c26073015.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and tc:IsMonster()) then return end
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tc:GetControler(),LOCATION_MZONE,0,tc)
	if e:GetLabel()==0x1 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(26073015,9)) then tc=g:Clone() end
	Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
end
function c26073015.xyzfilter(c,tp,lb)
	return (c:IsFaceup() or lb&0x8==0x8) and c:IsType(TYPE_XYZ) 
	and Duel.IsExistingMatchingCard(c26073015.ovfilter,tp,LOCATION_HAND|LOCATION_GRAVE|LOCATION_MZONE,0,1,c)
end
function c26073015.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lb=e:GetLabel()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c26073015.xyzfilter(chkc,lb) end
	if chk==0 then return Duel.IsExistingTarget(c26073015.xyzfilter,tp,LOCATION_MZONE,0,1,nil,tp,lb) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c26073015.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,lb)
	if lb==0x2 then Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1) end
end
function c26073015.rescon(sg,e,tp,mg)
	return #sg:Filter(Card.IsLocation,nil,LOCATION_ONFIELD)<2
	and #sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)<2
	and #sg:Filter(Card.IsLocation,nil,LOCATION_HAND)<2
end
function c26073015.ovfilter(c)
	return c:IsSetCard(0x673) and c:IsMonster()
end
function c26073015.activate2(e,tp,eg,ep,ev,re,r,rp)
	local lb=e:GetLabel()
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c26073015.ovfilter,tp,LOCATION_HAND|LOCATION_GRAVE|LOCATION_MZONE,0,tc)
	if tc:IsRelateToEffect(e) and (tc:IsFaceup() or lb&0x8==0x8)
	and tc:IsType(TYPE_XYZ) and not tc:IsImmuneToEffect(e)
	and #g>0 then
		local sg=aux.SelectUnselectGroup(g,e,tp,1,3,c26073015.rescon,1,tp,HINTMSG_ATTACH)
		if sg then
			Duel.Overlay(tc,sg)
			if lb==0x2 and Duel.IsPlayerCanDraw(tp,#sg)
			and Duel.SelectYesNo(tp,aux.Stringid(26073015,10)) then
				Duel.Draw(tp,#sg,REASON_EFFECT)
			end
		end
	end
end
function c26073015.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFacedown() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c26073015.activate3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and tc:IsMonster()) then return end
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tc:GetControler(),LOCATION_MZONE,0,tc)
	if e:GetLabel()==0x4 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(26073015,11)) then tc=g:Clone() end
	Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
end
function c26073015.filter4(c,e,b1,b2,b3)
	if not (b1 or b2 or b3) then
		b1=c:IsFaceup() and c:IsCanTurnSet() 
		b2=c:IsType(TYPE_XYZ)
		b3=c:IsFacedown() or b1
	end
	return c:IsCanBeEffectTarget(e)
	and (b1 and b2) or (b1 and b3) or (b2 and b3)
end
function c26073015.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lb=e:GetLabel()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c26073015.filter4(chkc,e,false,false,false)
	end
	if chk==0 then return Duel.IsExistingTarget(c26073015.filter4,tp,LOCATION_MZONE,0,1,nil,e,false,false,false) end
	local tc=Duel.SelectTarget(tp,c26073015.filter4,tp,LOCATION_MZONE,0,1,1,nil,e,false,false,false):GetFirst()
	local b1=tc:IsFaceup() and tc:IsCanTurnSet() 
	local b2=tc:IsType(TYPE_XYZ)
	local b3=tc:IsFacedown() or b1
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26073015,4))
	local op=Duel.SelectEffect(tp,
		{b1 and b2,aux.Stringid(26073015,5)},
		{b1 and b3,aux.Stringid(26073015,6)},
		{b2 and b3 and not b1,aux.Stringid(26073015,7)},
		{b1 and b2 and b3,aux.Stringid(26073015,8)})
	local CAT,val=0,0x8
	if op~=3 then
		CAT=CAT|CATEGORY_POSITION|CATEGORY_SET 
		Duel.SetOperationInfo(0,CATEGORY_POSITION,tc,1,tp,POS_FACEDOWN_DEFENSE)
		val=val|0x10
	end
	if op~=2 then
		val=val|0x100
	end
	if op~=1 then
		CAT=CAT|CATEGORY_POSITION 
		Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,tp,POS_FACEUP_ATTACK)
		val=val|0x1000
	end
	e:SetLabel(val)
	e:SetCategory(CAT)
end
function c26073015.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and tc:IsMonster()) then return end
	local lb=e:GetLabel()
	if lb&0x10==0x10 then
		c26073015.activate1(e,tp,eg,ep,ev,re,r,rp)
	end
	if lb&0x100==0x100 then
		c26073015.activate2(e,tp,eg,ep,ev,re,r,rp)
	end
	if lb&0x1000==0x1000 then
		c26073015.activate3(e,tp,eg,ep,ev,re,r,rp)
	end
end
