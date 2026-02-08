--Polterghast Cyclone
function c26073010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26073010.target)
	c:RegisterEffect(e1)
	--flip face up
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetDescription(aux.Stringid(26073010,0))
	e2:SetType(EFFECT_TYPE_TRIGGER_O|EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_MSET)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET|EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	--e2:SetCondition(c26073010.poscon)
	e2:SetTarget(c26073010.postg)
	e2:SetOperation(c26073010.posop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SSET)
	c:RegisterEffect(e3)
	--special summon flips/set and rearrange
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_POSITION|CATEGORY_SPECIAL_SUMMON|CATEGORY_SET)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET|EFFECT_FLAG_DELAY)
	e4:SetDescription(aux.Stringid(26073010,1))
	e4:SetType(EFFECT_TYPE_TRIGGER_O|EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,26073010)
	e4:SetCondition(c26073010.spcon)
	e4:SetTarget(c26073010.sptg)
	e4:SetOperation(c26073010.spop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	--Destroy3
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(26073010,2))
	e7:SetType(EFFECT_TYPE_TRIGGER_O|EFFECT_TYPE_FIELD)
	e7:SetCode(EVENT_CHANGE_POS)
	e7:SetRange(LOCATION_FZONE)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCondition(c26073010.shfcon)
	e7:SetTarget(c26073010.shftg)
	e7:SetOperation(c26073010.shfop)
	c:RegisterEffect(e7)
end
function c26073010.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()==0 then
			return c26073010.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		else
			return c26073010.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		end
	end
	if chk==0 then return true end
	local b1=c26073010.postg(e,tp,eg,ep,ev,re,r,rp,0)
	local b2=c26073010.sptg(e,tp,eg,ep,ev,re,r,rp,0)
	if (b1 or b2) and Duel.SelectYesNo(tp,94) then
		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(26073010,0),aux.Stringid(26073010,1))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(26073010,0))
		else
			op=Duel.SelectOption(tp,aux.Stringid(26073010,1))+1
		end
		e:SetLabel(op)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		if op==0 then
			c26073010.postg(e,tp,eg,ep,ev,re,r,rp,1)
			e:SetOperation(c26073010.posop)
			e:SetCategory(CATEGORY_POSITION)
		else
			e:SetCategory(CATEGORY_POSITION|CATEGORY_SPECIAL_SUMMON|CATEGORY_SET)
			c26073010.sptg(e,tp,eg,ep,ev,re,r,rp,1)
			e:SetOperation(c26073010.spop)
		end
	else
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c26073010.poscon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c26073010.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFacedown() end
	if chk==0 then return Duel.GetFlagEffect(tp,26073010)==0 and Duel.IsExistingTarget(Card.IsFacedown,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.RegisterFlagEffect(tp,26073010,RESET_PHASE|PHASE_END,0,1)
end
function c26073010.posop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFacedown() then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
	end
end
function c26073010.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(aux.NOT(Card.IsSummonPlayer),1,nil,tp)
end
function c26073010.ffilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c26073010.spfilter(c,e,tp)
	return (c:IsType(TYPE_FLIP) and c:IsLocation(LOCATION_HAND)
	or c:IsSetCard(0x673) and c:IsLocation(LOCATION_GRAVE))
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c26073010.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c26073010.ffilter(chkc) and chkc:IsControler(tp) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>0 and Duel.GetFlagEffect(tp,26073110)==0
		and Duel.IsExistingMatchingCard(c26073010.spfilter,tp,LOCATION_HAND|LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.IsExistingTarget(c26073010.ffilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c26073010.ffilter,tp,LOCATION_MZONE,0,1,7,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g*2+1,tp,POS_FACEDOWN_DEFENSE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND|LOCATION_GRAVE)
	Duel.RegisterFlagEffect(tp,26073110,RESET_PHASE|PHASE_END,0,1)
end
function c26073010.chkfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsLocation(LOCATION_MZONE)
	and c:IsFaceup()
end
function c26073010.spop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c26073010.chkfilter,nil,e)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local ft=math.min(ft,#g1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26073010.spfilter),tp,LOCATION_HAND|LOCATION_GRAVE,0,1,ft,nil,e,tp)
	if #g2>0 then
		Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		g1:Merge(Duel.GetOperatedGroup())
		if #g1>0 then
			Duel.ChangePosition(g1,POS_FACEDOWN_DEFENSE)
		end
	end
end
function c26073010.shfcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsFacedown,1,nil) 
end
function c26073010.xfilter(c)
	return (c:IsFaceup() or c:GetOverlayCount()>0)
	and c:IsType(TYPE_XYZ)
end
function c26073010.shftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MMZONE,0,2,nil) end
end
function c26073010.shfop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MMZONE,0,nil)
	Duel.ShuffleSetCard(g)
	local xg=Duel.GetMatchingGroup(c26073010.xfilter,tp,LOCATION_MZONE,0,nil)
	if #xg>0 and Duel.SelectYesNo(tp,aux.Stringid(tp,26073010)) then
	   local sc=xg:Select(tp,1,1,nil):GetFirst()
	   local sg=g:Select(tp,1,#g,sc) 
	   Duel.Overlay(sc,sg)
	end
end