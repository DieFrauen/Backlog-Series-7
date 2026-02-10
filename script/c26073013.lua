--Polterghast Approaches
function c26073013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26073013,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,26073013,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c26073013.target)
	e1:SetOperation(c26073013.activate)
	c:RegisterEffect(e1)
	--activate effect from graveyard
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26073013,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,26073013)
	e2:SetCondition(c26073013.spcon)
	e2:SetCost(Cost.SelfBanish)
	e2:SetTarget(c26073013.sptg)
	e2:SetOperation(c26073013.spop)
	c:RegisterEffect(e2)
	if not c26073013.global_check then
		c26073013.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c26073013.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c26073013.handcon)
	c:RegisterEffect(e3)
end
function c26073013.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase() or Duel.IsBattlePhase()
end
function c26073013.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local PHASE =Duel.GetCurrentPhase()
	for tc in aux.Next(eg) do
		tc:RegisterFlagEffect(26073013,RESET_EVENT|RESETS_STANDARD|RESET_PHASE+PHASE,0,1)
	end
end
function c26073013.handcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,26073010),tp,LOCATION_ONFIELD,0,1,nil)
	and not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) 
end
function c26073013.spfilter(c,e,tp)
	return c:IsSetCard(0x673) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c26073013.spcheck(sg,e,tp,mg)
	local mxg=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	return sg:GetClassCount(Card.GetLocation)==#sg
	and  sg:GetClassCount(Card.GetCode)==#sg
	and #sg<=mxg
end
function c26073013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local LOC = LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE 
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,0)
		local g=Duel.GetMatchingGroup(c26073013.spfilter,tp,LOC,0,nil,e,tp)
		return aux.SelectUnselectGroup(g,e,tp,1,3,c26073013.spcheck,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOC)
end
function c26073013.activate(e,tp,eg,ep,ev,re,r,rp)
	local LOC = LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE 
	local c=e:GetHandler()
	local ft=math.min(3,Duel.GetLocationCount(tp,LOCATION_MZONE,0))
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then
		ft=math.min(1,ft)
	end
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c26073013.spfilter),tp,LOC,0,nil,e,tp)
	if #sg==0 then return end
	local rg=aux.SelectUnselectGroup(sg,e,tp,1,ft,c26073013.spcheck,1,tp,HINTMSG_SPSUMMON)
	Duel.SpecialSummon(rg,0,tp,tp,true,false,POS_FACEDOWN_DEFENSE)
	Duel.ConfirmCards(1-tp,rg)
	Duel.ShuffleSetCard(rg)
end

function c26073013.spcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) and Duel.IsTurnPlayer(tp)
end
function c26073013.tgfilter(c,e,tp)
	local LOC =LOCATION_HAND|LOCATION_DECK|LOCATION_EXTRA|LOCATION_GRAVE 
	return c:IsFaceup() and c:HasFlagEffect(26073013)
	and Duel.IsExistingTarget(c26073013.spfilter,tp,LOC|c:GetSummonLocation(),0,1,nil,e,tp)
end
function c26073013.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c26073013.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c26073013.tgfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectTarget(tp,c26073013.tgfilter,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,tc:GetFirst():GetSummonLocation())
end
function c26073013.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup()
	and tc:IsControler(1-tp) then
		local LOC =tc:GetSummonLocation()
		local sc=Duel.SelectMatchingCard(tp,c26073013.tgfilter,tp,LOC,0,1,1,nil):GetFirst()
		if sc then 
			Duel.SpecialSummon(rg,0,tp,tp,true,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,rg)
		end
	end
end