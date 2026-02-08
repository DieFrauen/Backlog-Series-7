--Polterghast Metamorpheus
function c26073009.initial_effect(c)
	Xyz.AddProcedure(c,nil,nil,3,c26073009.ovfilter,aux.Stringid(26073009,0),6,c26073009.xyzop,false,c26073009.xyzcheck)
	c:EnableReviveLimit()
	--flip
	local effs={26073001,26073002,26073003,26073004,26073005}
	for i=1,5 do
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(effs[i],0))
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET|EFFECT_FLAG_DELAY)
		e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O|EFFECT_TYPE_FLIP)
		e1:SetCost(c26073009.flcost)
		e1:SetLabel(effs[i])
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		e2:SetCondition(c26073009.xcon)
		c:RegisterEffect(e2)
	end
	--leave field
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26073009,1))
	e3:SetCategory(CATEGORY_SET)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c26073009.setcon1)
	e3:SetTarget(c26073009.settg)
	e3:SetOperation(c26073009.setop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c26073009.setcon2)
	c:RegisterEffect(e4)
end
function c26073009.xcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsXyzSummoned() and Duel.IsPlayerAffectedByEffect(tp,26073008)
end
function c26073009.ovfilter(c,tp,lc)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
	and c:GetSequence()>4 and c:IsSetCard(0x673)
end
function c26073009.lvrk(c,v,chk)
	if c:IsHasEffect(511001175) then return false end
	return c:GetLevel()==v or (c:GetRank()==v and chk)
end
function c26073009.xyzcheck(g,tp,xyz)
	local m4=g:Filter(c26073009.lvrk,nil,4,false)
	local m2=g:Filter(c26073009.lvrk,nil,2,true)
	return (#m4==3 and #g==#m4) or (#m2==6 and #g==#m2)
end
function c26073009.rescon(sg,e,tp,mg)
	local lab=e:GetLabel()
	return sg:GetClassCount(Card.GetCode)==#sg 
	and not sg:IsExists(Card.IsCode,1,nil,lab) and
	(lab==c26073009 or sg:IsExists(Card.IsCode,1,nil,26068009))
	and #sg:Filter(Card.IsLocation,nil,LOCATION_HAND)<2
	and #sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)<2
	and #sg:Filter(Card.IsLocation,nil,LOCATION_EXTRA)<2
	and #sg:Filter(Card.IsLocation,nil,LOCATION_PZONE)<2
end
function c26073009.xyzop(e,tp,chk,mc)
	e:SetLabel(mc:GetCode())
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,0,mc)
	if chk==0 then return Duel.GetFlagEffect(tp,26073009)==0 and #g>3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg=g:Select(tp,0,4,mc)
	if #sg>3 then
		local sc=sg:GetFirst()
		for sc in aux.Next(sg) do
			Duel.SendtoGrave(sc:GetOverlayGroup(),REASON_RULE)
		end
		Duel.SendtoGrave(mc:GetOverlayGroup(),REASON_RULE)
		Duel.Overlay(mc,sg)
		Duel.RegisterFlagEffect(tp,26073009,0,0,1)
		return true
	else return false end
end
function c26073009.flcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lb=e:GetLabel()
	local og=e:GetHandler():GetOverlayGroup()
	local rc=og:Filter(Card.IsCode,nil,lb):GetFirst()
	local tg=rc and rc.fltg or nil
	local op=rc and rc.flop or nil
	local g=Group.CreateGroup()
	if chk==0 then return tg and tg(e,tp,g,2,0,e,0x40,2,0) end
	Duel.Hint(HINT_CARD,1-tp,rc:GetCode())
	e:SetTarget(tg)
	e:SetOperation(op)
end
function c26073009.setcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return e:GetHandler():GetOverlayCount()>0 and 
	c:IsPreviousPosition(POS_FACEDOWN)
end
function c26073009.setcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return e:GetHandler():GetOverlayCount()>0 and
	c:IsPreviousPosition(POS_FACEUP) and not
	c:IsLocation(LOCATION_DECK)
end
function c26073009.setfilter(c,e,p)
	return c:IsSSetable() or c:IsCanBeSpecialSummoned(e,0,p,false,false,POS_FACEDOWN_DEFENSE) 
end
function c26073009.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g1=Duel.GetMatchingGroup(c26073009.setfilter,0,LOCATION_HAND,0,nil,e,0)
	local g2=Duel.GetMatchingGroup(c26073009.setfilter,1,LOCATION_HAND,0,nil,e,1)
	if chk==0 then return #g1>0 or #g2>0 end
	Duel.SetOperationInfo(0,CATEGORY_SET,g1,#g1,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SET,g2,#g2,1,1)
end
function c26073009.setop(e,tp,eg,ep,ev,re,r,rp)
	local op=Duel.GetTurnPlayer()
	local g={op,1-op}
	for i=1,2 do
		local p=g[i]
		local sg=Duel.GetMatchingGroup(c26073009.setfilter,p,LOCATION_HAND,0,nil,e,p)
		while #sg>0 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sc=sg:Select(p,1,1,nil):GetFirst()
			local b1=sc:IsCanBeSpecialSummoned(e,0,p,false,false,POS_FACEDOWN_DEFENSE)
			local b2=sc:IsSSetable()
			local op=0
			if (b1 and b2) then
				Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(26073009,2))
				op=Duel.SelectEffect(p,
					{b1,aux.Stringid(26073009,3)},
					{b2,aux.Stringid(26073009,4)})
			elseif b1 then op=1
			else op=2 end
			if op==1 then
				Duel.SpecialSummon(sc,0,p,p,false,false,POS_FACEDOWN_DEFENSE)
			end
			if op==2 then
				Duel.SSet(p,sc,p,false)
			end
			sg:Sub(sc)
		end
	end
	local g1=Duel.GetMatchingGroup(nil,op,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(nil,op,0,LOCATION_HAND,nil)
	if #g1==0 and #g2==0 then return end
	Duel.BreakEffect()
	if #g1>0 then
		Duel.SendtoDeck(g1,nil,2,REASON_RULE)
	end
	if #g2>0 then
		Duel.SendtoDeck(g2,nil,2,REASON_RULE)
	end
end