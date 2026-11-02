--Theriomachia - Delta Erinys
function c26074008.initial_effect(c)
	c:EnableReviveLimit()
	Synchro.AddProcedure(c,aux.FilterSummonCode(26074004),1,1,Synchro.NonTuner(nil),1,99)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(26074008,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	e0:SetCondition(c26074008.hspcon)
	e0:SetTarget(c26074008.hsptg)
	e0:SetOperation(c26074008.hspop)
	c:RegisterEffect(e0)
	--special summon
	local e0a=Effect.CreateEffect(c)
	e0a:SetType(EFFECT_TYPE_FIELD)
	e0a:SetCode(EFFECT_SPSUMMON_PROC)
	e0a:SetDescription(aux.Stringid(26074008,0))
	e0a:SetProperty(EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0a:SetTargetRange(POS_FACEUP_ATTACK,0)
	e0a:SetRange(LOCATION_MZONE)
	e0a:SetCountLimit(1)
	e0a:SetCondition(c26074008.syncon)
	e0a:SetTarget(c26074008.syntg)
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
	e0c:SetValue(2)
	e0c:SetCondition(Gemini.NormalStatusCondition)
	c:RegisterEffect(e0c)
	--normal in response to search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetDescription(aux.Stringid(26074008,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CUSTOM+26074008)
	e1:SetCondition(Gemini.EffectStatusCondition)
	e1:SetCondition(c26074008.condition1)
	e1:SetTarget(c26074008.target1)
	e1:SetOperation(c26074008.operation1)
	c:RegisterEffect(e1)
	--destroy target
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(26074008,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET|EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1)
	e2:SetCondition(Gemini.EffectStatusCondition)
	e2:SetTarget(c26074008.target2)
	e2:SetOperation(c26074008.operation2)
	c:RegisterEffect(e2)
	aux.GlobalCheck(c26074008,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetCondition(c26074008.regcon)
		ge1:SetOperation(c26074008.regop)
		Duel.RegisterEffect(ge1,0)
	end)
	--untargetable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetCondition(Gemini.EffectStatusCondition)
	e3:SetTarget(function(_,c) return c:IsGeminiStatus() end)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	
end
c26074008.listed_names={26074004}
c26074008.material={26074004}
function c26074008.hspfilter(c,tp,sc)
	return c:IsCode(26074004)
	and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
end
function c26074008.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroup(c:GetControler(),c26074008.hspfilter,1,true,1,true,c,c:GetControler(),nil,false,nil,tp,c)
end
function c26074008.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.SelectReleaseGroup(tp,c26074008.hspfilter,0,1,true,true,true,c,nil,nil,false,nil,tp,c)
	if g and #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else
		return false
	end
end
function c26074008.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	local lv=g:GetFirst():GetLevel()
	Duel.Release(g,REASON_COST|REASON_RELEASE)
	c:SetMaterial(g)
	g:DeleteGroup()
end

function c26074008.syncon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local lv,olv=c:GetLevel(),c:GetOriginalLevel()
	e:SetLabel(olv-lv)
	local g=Duel.GetMatchingGroup(c26074008.mtfilter,tp,LOCATION_MZONE,0,nil,c)
	return not (c:IsGeminiState() and c:IsType(TYPE_EFFECT)) and e:GetLabel()>0 and aux.SelectUnselectGroup(g,e,tp,1,99,c26074008.rescon,0)
end
function c26074008.mtfilter(c,sc)
	return c:IsCanBeSynchroMaterial(sc)
end
function c26074008.rescon(sg,e,tp,mg)
	return sg:GetSum(Card.GetLevel)==e:GetLabel()
end
function c26074008.syntg(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local lv,olv=c:GetLevel(),c:GetOriginalLevel()
	e:SetLabel(olv-lv)
	local g=Duel.GetMatchingGroup(c26074008.mtfilter,tp,LOCATION_MZONE,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	sg=aux.SelectUnselectGroup(g,e,tp,1,99,c26074008.rescon,1,tp,aux.Stringid(26074008,1),nil,nil,true)
	if #sg>0 then
		Duel.HintSelection(Group.FromCards(c))
		c:EnableGeminiState()
		c:SetMaterial(sg)
		Duel.SendtoGrave(sg,REASON_RELEASE)
		return true
	end
	return false
end
function c26074008.cfilter(c,tp)
	return c:IsControler(tp)	
	and not c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c26074008.regcon(e,tp,eg,ep,ev,re,r,rp)
	if --Duel.IsPhase(PHASE_DRAW) or 
		Duel.IsPhase(PHASE_DAMAGE) then return false end
	local v=0
	if eg:IsExists(c26074008.cfilter,1,nil,0) then v=v+1 end
	if eg:IsExists(c26074008.cfilter,1,nil,1) then v=v+2 end
	if v==0 then return false end
	e:SetLabel(({0,1,PLAYER_ALL})[v])
	return true
end
function c26074008.condition1(e,tp,eg,ep,ev,re,r,rp,chk)
	return (ev==1-tp or ev==PLAYER_ALL)
	and Gemini.EffectStatusCondition(e)
end
function c26074008.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+26074008,re,r,rp,ep,e:GetLabel())
end
function c26074008.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSummonable,tp,LOCATION_HAND|LOCATION_MZONE,0,1,nil,true) and c:GetFlagEffect(26074008)==0 end
	c:RegisterFlagEffect(26074008,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c26074008.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,Card.IsSummonable,tp,LOCATION_HAND|LOCATION_MZONE,0,1,1,nil,true)
	local tc=g:GetFirst()
	if tc then Duel.Summon(tp,tc,true,nil) end
end
function c26074008.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,0)
end
function c26074008.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end