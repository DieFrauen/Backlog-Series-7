--Theriomachine Ignition
function c26074013.initial_effect(c)
	--double summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26074013,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c26074013.cost)
	e1:SetTarget(c26074013.target1)
	e1:SetOperation(c26074013.activate1)
	c:RegisterEffect(e1)
	--geminize + summon
	local e2=e1:Clone()
	e1:SetCategory(CATEGORY_SUMMON)
	e2:SetDescription(aux.Stringid(26074013,1))
	e2:SetTarget(c26074013.target2)
	e2:SetOperation(c26074013.activate2)
	c:RegisterEffect(e2)
	--search
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(26074013,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCost(c26074013.cost3)
	e3:SetTarget(c26074013.target3)
	e3:SetOperation(c26074013.activate3)
	c:RegisterEffect(e3)
	--activate on discard
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26074013,3))
	e4:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DISCARD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,26074013)
	e4:SetTarget(c26074013.target4)
	c:RegisterEffect(e4)
	--register summon
	aux.GlobalCheck(c26074013,function()
		c26074013.attr_list={}
		c26074013.attr_list[0]=0
		c26074013.attr_list[1]=0
		c26074013.rc_list={}
		c26074013.rc_list[0]=0
		c26074013.rc_list[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c26074013.regop)
		Duel.RegisterEffect(ge1,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE+PHASE_END)
		ge1:SetCountLimit(1)
		ge1:SetCondition(c26074013.resetop)
		Duel.RegisterEffect(ge1,0)
	end)
end
function c26074013.reg(c)
	local p=c:GetSummonPlayer()
	c26074013.attr_list[p]=c26074013.attr_list[p]|c:GetAttribute()
	c26074013.rc_list[p]=c26074013.rc_list[p]|c:GetRace()
end
function c26074013.regop(e,tp,eg,ep,ev,re,r,rp)
	eg:ForEach(c26074013.reg)
end
function c26074013.resetop(e,tp,eg,ep,ev,re,r,rp)
	c26074013.attr_list[0]=0;c26074013.rc_list[0]=0
	c26074013.attr_list[1]=0;c26074013.rc_list[1]=0
	return false
end
function c26074013.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	c26074013.check=true
	if chk==0 then return true end
end
function c26074013.spcheck(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetLocation)==#sg
	and sg:IsExists(Card.IsSetCard,1,nil,0x674)
	and (sg:GetClassCount(Card.GetRace)==#sg
	or sg:GetClassCount(Card.GetAttribute)<2)
end
function c26074013.filter1(c,e,tp)
	return c:IsType(TYPE_GEMINI) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp)
end
function c26074013.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not c26074013.check then return false end
		c26074013.check=false
		local ct=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD)
		local g=Duel.GetMatchingGroup(c26074013.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
		return ct>0 and aux.SelectUnselectGroup(g,e,tp,1,2,c26074013.spcheck,0) and Duel.GetFlagEffect(tp,26074013)==0
	end
	Duel.RegisterFlagEffect(tp,26074013,RESET_PHASE|PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c26074013.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local sg=Duel.GetMatchingGroup(c26074013.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	if #sg==0 or ct==0 then return end
	if ct>2 then ct=2 end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ct=1 end
	local rg=aux.SelectUnselectGroup(sg,e,tp,1,2,c26074013.spcheck,1,tp,HINTMSG_SPSUMMON)
	if #rg>0 then
		Duel.SpecialSummon(rg,0,tp,tp,true,false,POS_FACEUP_DEFENSE,zone)
	end
end
function c26074013.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not c26074013.check then return false end
		c26074013.check=false
		local ct=0
		local ce={Duel.IsPlayerAffectedByEffect(tp,EFFECT_SET_SUMMON_COUNT_LIMIT)}
		for _,te in ipairs(ce) do
			ct=math.max(ct,te:GetValue())
		end
		return ct<6 and Duel.GetFlagEffect(tp,26074113)==0
	end
	Duel.RegisterFlagEffect(tp,26074113,RESET_PHASE|PHASE_END,0,1)
end
function c26074013.activate2(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(6)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetReset(RESET_PHASE|PHASE_END)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c26074013.splimit)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetDescription(aux.Stringid(26074013,4))
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	Duel.RegisterEffect(e3,tp)
end
function c26074013.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	if c:IsType(TYPE_GEMINI) then return false end
	if c:GetLocation()&LOCATION_HAND|LOCATION_DECK ==0
	then return false end
	return c26074013.attr_list[sump]&c:GetAttribute()==0
	and c26074013.rc_list[sump]&c:GetRace()==0
end
function c26074013.cfilter(c,e,tp)
	return Duel.GetMZoneCount(tp,c)>0 and c:IsReleasable()
		and Duel.IsExistingMatchingCard(c26074013.deckspfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetOriginalAttribute())
end
function c26074013.filter3(c,e,tp,att)
	return c:IsSetCard(0x2674) and c:IsOriginalAttribute(att)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26074013.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	c26074013.check=true
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c26074013.cfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sc=Duel.SelectReleaseGroupEx(tp,c26074013.cfilter,1,1,nil,e,tp):GetFirst()
	local cd=e:GetChainData()
	cd.attribute=sc:GetOriginalAttribute()
	cd.level=sc:GetOriginalLevel()
	Duel.Release(sc,REASON_COST)
end
function c26074013.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if not c26074013.check then return false end
		c26074013.check=false
		return Duel.GetFlagEffect(tp,26074213)==0
	end
	Duel.RegisterFlagEffect(tp,26074213,RESET_PHASE|PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c26074013.activate3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local cd=e:GetChainData()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c26074013.filter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,cd.attribute):GetFirst()
	if tc then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetDescription(aux.Stringid(26074011,0))
		e1:SetProperty(EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetTargetRange(POS_FACEUP_ATTACK,0)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD -RESET_TOFIELD)
		e1:SetCountLimit(1)
		e1:SetCondition(c26074011.xcon)
		e1:SetTarget(c26074011.xtg)
		e1:SetValue(SUMMON_TYPE_SYNCHRO)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_REMOVE_TYPE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD -RESET_TOFIELD)
		e2:SetValue(TYPE_EFFECT)
		e2:SetCondition(Gemini.NormalStatusCondition)
		e2:SetRange(LOCATION_MZONE)
		tc:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
		e3:SetValue(cd.level)
		tc:RegisterEffect(e3)
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c26074013.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	c26074013.check=true
	local tg1=c26074013.target1(e,tp,eg,ep,ev,re,r,rp,0)
	c26074013.check=true
	local tg2=c26074013.target2(e,tp,eg,ep,ev,re,r,rp,0)
	c26074013.check=true
	local tg3=c26074013.target3(e,tp,eg,ep,ev,re,r,rp,0)
	if chk==0 then return tg1 or tg2 or tg3 end
	e:SetCategory(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectEffect(tp,
		{tg1,aux.Stringid(26074013,0)},
		{tg2,aux.Stringid(26074013,1)},
		{tg3,aux.Stringid(26074013,2)}) 
	if op==1 then
		e:SetCategory(CATEGORY_SUMMON|CATEGORY_DRAW)
		c26074013.target1(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetOperation(c26074013.activate1)
	end
	if op==2 then
		e:SetCategory(CATEGORY_SUMMON)
		c26074013.target2(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetOperation(c26074013.activate2)
	end
	if op==3 then
		e:SetCategory(CATEGORY_TOHAND|CATEGORY_SEARCH)
		c26074013.cost3(e,tp,eg,ep,ev,re,r,rp,1)
		c26074013.target3(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetOperation(c26074013.activate3)
	end
end
