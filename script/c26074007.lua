--Theriomachia - Epsilenos
function c26074007.initial_effect(c)
	c:EnableReviveLimit()
	Synchro.AddProcedure(c,aux.FilterSummonCode(26074005),1,1,Synchro.NonTuner(nil),1,99)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	e0:SetCondition(c26074007.hspcon)
	e0:SetTarget(c26074007.hsptg)
	e0:SetOperation(c26074007.hspop)
	c:RegisterEffect(e0)
	--special summon
	local e0a=Effect.CreateEffect(c)
	e0a:SetType(EFFECT_TYPE_FIELD)
	e0a:SetCode(EFFECT_SPSUMMON_PROC)
	e0a:SetDescription(aux.Stringid(26074007,0))
	e0a:SetProperty(EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0a:SetTargetRange(POS_FACEUP_ATTACK,0)
	e0a:SetRange(LOCATION_MZONE)
	e0a:SetCountLimit(1)
	e0a:SetCondition(c26074007.syncon)
	e0a:SetTarget(c26074007.syntg)
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
	e0c:SetValue(1)
	e0c:SetCondition(Gemini.NormalStatusCondition)
	c:RegisterEffect(e0c)
	--normal in response to search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetDescription(aux.Stringid(26074007,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c26074007.condition1)
	e1:SetTarget(c26074007.target1)
	e1:SetOperation(c26074007.operation1)
	c:RegisterEffect(e1)
	--destroy target
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetDescription(aux.Stringid(26074007,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET|EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(c26074007.condition2)
	e2:SetTarget(c26074007.target2)
	e2:SetOperation(c26074007.operation2)
	c:RegisterEffect(e2)
end
c26074007.listed_names={26074005}
c26074007.material={26074005}
function c26074007.hspfilter(c,tp,sc)
	return c:IsCode(26074005)
	and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
end
function c26074007.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroup(c:GetControler(),c26074007.hspfilter,1,true,1,true,c,c:GetControler(),nil,false,nil,tp,c)
end
function c26074007.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.SelectReleaseGroup(tp,c26074007.hspfilter,0,1,true,true,true,c,nil,nil,false,nil,tp,c)
	if g and #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else
		return false
	end
end
function c26074007.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	local lv=g:GetFirst():GetLevel()
	Duel.Release(g,REASON_COST|REASON_RELEASE)
	c:SetMaterial(g)
	g:DeleteGroup()
end

function c26074007.syncon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local lv,olv=c:GetLevel(),c:GetOriginalLevel()
	e:SetLabel(olv-lv)
	local g=Duel.GetMatchingGroup(c26074007.mtfilter,tp,LOCATION_MZONE,0,nil,c)
	return not (c:IsGeminiState() and c:IsType(TYPE_EFFECT)) and e:GetLabel()>0 and aux.SelectUnselectGroup(g,e,tp,1,99,c26074007.rescon,0)
end
function c26074007.mtfilter(c,sc)
	return c:IsCanBeSynchroMaterial(sc)
end
function c26074007.rescon(sg,e,tp,mg)
	return sg:GetSum(Card.GetLevel)==e:GetLabel()
end
function c26074007.syntg(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local lv,olv=c:GetLevel(),c:GetOriginalLevel()
	e:SetLabel(olv-lv)
	local g=Duel.GetMatchingGroup(c26074007.mtfilter,tp,LOCATION_MZONE,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	sg=aux.SelectUnselectGroup(g,e,tp,1,99,c26074007.rescon,1,tp,aux.Stringid(26074007,1),nil,nil,true)
	if #sg>0 then
		Duel.HintSelection(Group.FromCards(c))
		c:EnableGeminiState()
		c:SetMaterial(sg)
		Duel.SendtoGrave(sg,REASON_RELEASE)
		return true
	end
	return false
end
function c26074007.condition1(e,tp,eg,ep,ev,re,r,rp,chk)
	return rp==1-tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)
	and re:IsSpellTrapEffect() and Gemini.EffectStatusCondition(e)
end
function c26074007.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSummonable,tp,LOCATION_HAND|LOCATION_MZONE,0,1,nil,true) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c26074007.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,Card.IsSummonable,tp,LOCATION_HAND|LOCATION_MZONE,0,1,1,nil,true)
	local tc=g:GetFirst()
	if tc then Duel.Summon(tp,tc,true,nil) end
end
function c26074007.condition2(e,tp,eg,ep,ev,re,r,rp,chk)
	return eg:IsExists(Card.IsType,1,nil,TYPE_GEMINI)
	and Gemini.EffectStatusCondition(e)
end
function c26074007.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.GetFieldGroup(tp,0,LOCATION_HAND) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,g,1,1-tp,0)
end
function c26074007.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1):GetFirst()
	Duel.ConfirmCards(tp,tc)
	local rc,at=e:GetLabel()
	if tc:IsMonster() and tc:IsSummonable(true,nil) and Duel.SelectYesNo(tp,aux.Stringid(26074007,3)) then
		Duel.Summon(1-tp,tc,true,nil)
	else Duel.ShuffleHand(1-tp) end
end