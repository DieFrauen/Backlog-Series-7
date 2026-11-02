--Theriomachia - Lambda Larva
function c26074006.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	e0:SetCondition(c26074006.hspcon)
	e0:SetTarget(c26074006.hsptg)
	e0:SetOperation(c26074006.hspop)
	c:RegisterEffect(e0)
	--special summon
	local e0a=Effect.CreateEffect(c)
	e0a:SetType(EFFECT_TYPE_FIELD)
	e0a:SetCode(EFFECT_SPSUMMON_PROC)
	e0a:SetDescription(aux.Stringid(26074006,0))
	e0a:SetProperty(EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0a:SetTargetRange(POS_FACEUP_ATTACK,0)
	e0a:SetRange(LOCATION_MZONE)
	e0a:SetReset(RESET_EVENT+RESETS_STANDARD -RESET_TOFIELD)
	e0a:SetCountLimit(1)
	e0a:SetCondition(c26074006.syncon)
	e0a:SetTarget(c26074006.syntg)
	e0a:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0a)
	local e0b=Effect.CreateEffect(c)
	e0b:SetType(EFFECT_TYPE_SINGLE)
	e0b:SetCode(EFFECT_REMOVE_TYPE)
	e0b:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e0b:SetValue(TYPE_EFFECT)
	e0b:SetCondition(Gemini.NormalStatusCondition)
	e0b:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e0b)
	local e0c=e0b:Clone()
	e0b:SetValue(TYPE_TUNER)
	c:RegisterEffect(e0c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(Gemini.EffectStatusCondition)
	e1:SetTarget(c26074006.thtg)
	e1:SetOperation(c26074006.thop)
	c:RegisterEffect(e1)
	--cannot negate normals
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_RANGE|EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTarget(aux.TRUE)
	e2:SetCondition(Gemini.EffectStatusCondition)
	c:RegisterEffect(e2)
end
c26074006.listed_series={0x674}
function c26074006.hspfilter(c,tp,sc)
	return c:IsSetCard(0x674) and c:IsType(TYPE_GEMINI,sc,MATERIAL_SYNCHRO,tp) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
end
function c26074006.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroup(c:GetControler(),c26074006.hspfilter,1,false,1,true,c,c:GetControler(),nil,false,nil,tp,c)
		and Duel.GetFlagEffect(tp,26074006)==0 
end
function c26074006.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.SelectReleaseGroup(tp,c26074006.hspfilter,0,1,false,true,true,c,nil,nil,false,nil,tp,c)
	if g and #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else
		return false
	end
end
function c26074006.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	local lv=g:GetFirst():GetLevel()
	Duel.Release(g,REASON_COST|REASON_RELEASE)
	c:SetMaterial(g)
	Duel.RegisterFlagEffect(tp,26074006,RESET_PHASE+PHASE_END,0,1)
	g:DeleteGroup()
end

function c26074006.syncon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c26074006.mtfilter,tp,LOCATION_MZONE,0,c,c)
	return not (c:IsGeminiState() and c:IsType(TYPE_EFFECT)) and #g>0
end
function c26074006.mtfilter(c,sc)
	return c:IsLevelAbove(1) and c:IsReleasable()
end
function c26074006.syntg(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c26074006.mtfilter,tp,LOCATION_MZONE,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	sg=g:Select(tp,1,1,c)
	if #sg==1 then
		Duel.HintSelection(Group.FromCards(c))
		c:EnableGeminiState()
		--c:SetMaterial(sg)
		local lv=sg:GetFirst():GetLevel()
		Duel.SendtoGrave(sg,REASON_RELEASE)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(c:GetLevel()+lv)
		e2:SetRange(LOCATION_MZONE)
		c:RegisterEffect(e2)
		return true
	end
	return false
end

function c26074006.eqfilter(c,cd)
	return c:IsCode(cd) and (c:IsFaceup() or not c:IsOnField())
end
function c26074006.filter(c,tp)
	return c:IsSetCard(0x674) and c:IsAbleToHand()
		and not Duel.IsExistingMatchingCard(c26074006.eqfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function c26074006.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26074006.filter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26074006.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26074006.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end