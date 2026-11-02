--Deus Ex Theriomachia - Ohm Megalion
function c26074012.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_SYNCHRO),1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetDescription(aux.Stringid(26074012,0))
	e0:SetProperty(EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetTargetRange(POS_FACEUP_ATTACK,0)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1)
	e0:SetCondition(c26074012.syncon)
	e0:SetTarget(c26074012.syntg)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	local e0a=Effect.CreateEffect(c)
	e0a:SetType(EFFECT_TYPE_SINGLE)
	e0a:SetCode(EFFECT_REMOVE_TYPE)
	e0a:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e0a:SetValue(TYPE_EFFECT)
	e0a:SetCondition(Gemini.NormalStatusCondition)
	e0a:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e0a)
	local e0b=e0a:Clone()
	e0b:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
	e0b:SetCondition(Gemini.EffectStatusCondition)
	e0b:SetValue(24)
	c:RegisterEffect(e0b)
	--destroy target
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK|CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(26074012,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetCondition(Gemini.EffectStatusCondition)
	e1:SetTarget(c26074012.target1)
	e1:SetOperation(c26074012.operation1)
	c:RegisterEffect(e1)
	--destroy target
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetDescription(aux.Stringid(26074012,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET|EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(c26074012.condition2)
	e2:SetTarget(c26074012.target2)
	e2:SetOperation(c26074012.operation2)
	c:RegisterEffect(e2)
	local e2a=e2:Clone()
	e2a:SetCondition(c26074012.condition22)
	e2a:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2a)
	--untargetable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetTarget(function(_,c) return c:IsGeminiStatus() end)
	e3:SetValue(c26074012.immval)
	c:RegisterEffect(e3)
end
function c26074012.mtfilter(c,sc)
	return c:IsCanBeSynchroMaterial(sc)
end
function c26074012.rescon(sg,e,tp,mg)
	return sg:IsExists(Card.IsType,1,nil,TYPE_TUNER|TYPE_GEMINI)
	and sg:GetSum(Card.GetLevel)==12
end
function c26074012.syncon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c26074012.mtfilter,tp,LOCATION_MZONE,0,nil,c)
	return not (c:IsGeminiState() and c:IsType(TYPE_EFFECT))
	and aux.SelectUnselectGroup(g,e,tp,1,99,c26074012.rescon,0)
end
function c26074012.syntg(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26074012.mtfilter,tp,LOCATION_MZONE,0,nil,c)
	local sg=aux.SelectUnselectGroup(g,e,tp,1,#g,c26074012.rescon,1,tp,HINTMSG_SMATERIAL,nil,nil,true)
	if sg:GetSum(Card.GetSynchroLevel,c)==12 then
		Duel.HintSelection(sg)
		c:EnableGeminiState()
		c:SetMaterial(sg)
		Duel.SendtoGrave(sg,REASON_RELEASE)
		return true
	end
	return false
end
function c26074012.txfilter(c,sc)
	return c:IsType(TYPE_SYNCHRO) and c:IsAbleToExtra(c)
end
function c26074012.immval(e,te)
	if not te:IsActivated() then return false end
	local tf=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_TYPE)
	return tf&TYPE_MONSTER>0 and not te:GetHandler():IsType(TYPE_GEMINI)
end
function c26074012.spfilter(c,e,tp,sc,ft)
	return c:IsCode(table.unpack(sc.material))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26074012.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26074012.txfilter,tp,LOCATION_ONFIELD|LOCATION_GRAVE,LOCATION_ONFIELD|LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_GRAVE|LOCATION_DECK)
end
function c26074012.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c26074012.txfilter,tp,LOCATION_ONFIELD|LOCATION_GRAVE,LOCATION_ONFIELD|LOCATION_GRAVE,1,1,nil)
	if #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c26074012.spfilter),tp,LOCATION_GRAVE|LOCATION_DECK,0,nil,e,tp,tc,ft)
		if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(26074012,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=sg:Select(tp,1,1,nil)
			Duel.ConfirmCards(1-tc:GetControler(),tc)
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c26074012.tfilter(c)
	return c:IsType(TYPE_GEMINI) and c:IsFaceup()
end
function c26074012.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26074012.tfilter,1,nil) 
	and not eg:IsContains(e:GetHandler())
	and Gemini.EffectStatusCondition(e)
end
function c26074012.condition22(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_SYNCHRO) 
	and c26074012.condition2(e,tp,eg,ep,ev,re,r,rp)
end
function c26074012.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_GEMINI) and not c:IsGeminiStatus()
end
function c26074012.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingTarget(c26074012.filter2,tp,LOCATION_HAND|LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c26074012.filter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c26074012.ngfilter(c,at,rc,lv)
	return (c:IsAttribute(at)
		or c:IsRace(rc)
		or c:IsLevel(lv))
	and c:IsFaceup() and c:IsNegatableMonster()
end
function c26074012.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and c26074012.filter2(tc) then
		Duel.HintSelection(tc)
		tc:EnableGeminiStatus()
		local at=tc:GetAttribute()
		local rc=tc:GetRace()
		local lv=tc:GetLevel()
		if Duel.IsExistingMatchingCard(c26074012.ngfilter,tp,0,LOCATION_MZONE,1,nil,at,rc,lv)
			and Duel.SelectEffectYesNo(tp,c,aux.Stringid(26074012,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sc=Duel.SelectMatchingCard(tp,c26074012.ngfilter,tp,0,LOCATION_MZONE,1,1,nil,at,rc,lv):GetFirst()
			if sc then
				Duel.HintSelection(sc)
				Duel.BreakEffect()
				sc:NegateEffects(c,RESET_EVENT|RESETS_STANDARD)
			end
		end
	end
end