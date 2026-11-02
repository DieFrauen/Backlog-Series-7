--Theriomachia - Gamma Armaid
function c26074009.initial_effect(c)
	c:EnableReviveLimit()
	Synchro.AddProcedure(c,aux.FilterSummonCode(26074003),1,1,Synchro.NonTuner(nil),1,99)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	e0:SetCondition(c26074009.hspcon)
	e0:SetTarget(c26074009.hsptg)
	e0:SetOperation(c26074009.hspop)
	c:RegisterEffect(e0)
	--special summon
	local e0a=Effect.CreateEffect(c)
	e0a:SetType(EFFECT_TYPE_FIELD)
	e0a:SetCode(EFFECT_SPSUMMON_PROC)
	e0a:SetDescription(aux.Stringid(26074009,0))
	e0a:SetProperty(EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0a:SetTargetRange(POS_FACEUP_ATTACK,0)
	e0a:SetRange(LOCATION_MZONE)
	e0a:SetCountLimit(1)
	e0a:SetCondition(c26074009.syncon)
	e0a:SetTarget(c26074009.syntg)
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
	e0c:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
	e0c:SetValue(3)
	e0c:SetCondition(Gemini.NormalStatusCondition)
	c:RegisterEffect(e0c)
	--negate Spell/Trap
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetDescription(aux.Stringid(26074009,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET|EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetCondition(Gemini.EffectStatusCondition)
	e2:SetTarget(c26074009.target2)
	e2:SetOperation(c26074009.operation2)
	c:RegisterEffect(e2)
	--inactivatable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_INACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(Gemini.EffectStatusCondition)
	e3:SetValue(c26074009.effectfilter)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_DISEFFECT)
	c:RegisterEffect(e4)
end
c26074009.listed_names={26074003}
c26074009.material={26074003}
function c26074009.hspfilter(c,tp,sc)
	return c:IsCode(26074003)
	and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
end
function c26074009.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroup(c:GetControler(),c26074009.hspfilter,1,true,1,true,c,c:GetControler(),nil,false,nil,tp,c)
end
function c26074009.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.SelectReleaseGroup(tp,c26074009.hspfilter,0,1,true,true,true,c,nil,nil,false,nil,tp,c)
	if g and #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else
		return false
	end
end
function c26074009.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	local lv=g:GetFirst():GetLevel()
	Duel.Release(g,REASON_COST|REASON_RELEASE)
	c:SetMaterial(g)
	g:DeleteGroup()
end

function c26074009.syncon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local lv,olv=c:GetLevel(),c:GetOriginalLevel()
	e:SetLabel(olv-lv)
	local g=Duel.GetMatchingGroup(c26074009.mtfilter,tp,LOCATION_MZONE,0,nil,c)
	return not (c:IsGeminiState() and c:IsType(TYPE_EFFECT)) and e:GetLabel()>0 and aux.SelectUnselectGroup(g,e,tp,1,99,c26074009.rescon,0)
end
function c26074009.mtfilter(c,sc)
	return c:IsCanBeSynchroMaterial(sc)
end
function c26074009.rescon(sg,e,tp,mg)
	return sg:GetSum(Card.GetLevel)==e:GetLabel()
end
function c26074009.syntg(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local lv,olv=c:GetLevel(),c:GetOriginalLevel()
	e:SetLabel(olv-lv)
	local g=Duel.GetMatchingGroup(c26074009.mtfilter,tp,LOCATION_MZONE,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	sg=aux.SelectUnselectGroup(g,e,tp,1,99,c26074009.rescon,1,tp,aux.Stringid(26074009,1),nil,nil,true)
	if #sg>0 then
		Duel.HintSelection(Group.FromCards(c))
		c:EnableGeminiState()
		c:SetMaterial(sg)
		Duel.SendtoGrave(sg,REASON_RELEASE)
		return true
	end
	return false
end
function c26074009.sumfilter(c)
	return c:IsSetCard(0x674) and c:IsSummonable(true,nil)
end
function c26074009.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField()
		and chkc:IsNegatableSpellTrap() end
	if chk==0 then return
		Duel.IsExistingMatchingCard(c26074009.sumfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(Card.IsNegatableSpellTrap,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsNegatableSpellTrap,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c26074009.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c26074009.sumfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,1,1,nil,true)
	local sc=g:GetFirst()
	if Duel.Summon(tp,sc,true,nil)~=0 and tc and tc:IsRelateToEffect(e) then
		tc:NegateEffects(e:GetHandler(),RESETS_STANDARD_PHASE_END)
	end
end
function c26074009.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	local tc=te:GetHandler()
	return p==tp and tc:IsType(TYPE_GEMINI) and loc&LOCATION_ONFIELD~=0 and tc:IsGeminiState()
end