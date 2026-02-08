--Polterghast Cumulos
function c26073001.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26073001,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET|EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O|EFFECT_TYPE_FLIP)
	e1:SetTarget(c26073001.fltg)
	e1:SetOperation(c26073001.flop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26073001,2))
	e2:SetCategory(CATEGORY_SET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,26073001)
	e2:SetTarget(c26073001.tftg)
	e2:SetOperation(c26073001.tfop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e3)
	--untargetable (including as material)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(26073001)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	c:RegisterEffect(e4)
	aux.GlobalCheck(c26073001,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		ge1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		ge1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		ge1:SetTarget(function(e,c)
			local cp=c:GetControler()
			return c:IsFacedown() and e:GetHandlerPlayer()==cp and
			(Duel.IsPlayerAffectedByEffect(cp,26073001)
			or Duel.IsExistingMatchingCard(c26073001.untfilter,cp,LOCATION_MZONE,0,1,nil)) end)
		ge1:SetValue(aux.tgoval)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		Duel.RegisterEffect(ge2,1)
	end)
end
function c26073001.untfilter(c)
	return c:IsFacedown() and c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,26073001)
end
function c26073001.rescon(sg,e,tp,mg)
	return sg:IsExists(Card.IsSpellTrap,1,nil)
end
function c26073001.fltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local rg=Duel.GetMatchingGroup(Card.IsCanBeEffectTarget,tp,0,LOCATION_ONFIELD,nil,e)
	if chk==0 then return Duel.IsExistingTarget(Card.IsSpellTrap,tp,0,LOCATION_ONFIELD,1,nil,e) end
	local g=aux.SelectUnselectGroup(rg,e,tp,1,3,c26073001.rescon,1,tp,HINTMSG_RTOHAND)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,tp,0)
end
function c26073001.flop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetCards(e)
	local sg=tg:Filter(Card.IsSpellTrap,nil)
	if #sg==0 then return end
	local p=tp
	if not Duel.IsPlayerAffectedByEffect(tp,26073014) then p=1-tp end
	tc=tg:Select(p,#sg,#sg,nil)
	Duel.Destroy(tc,REASON_EFFECT)
end
function c26073001.tffilter(c)
	return c:IsSetCard(0x673) and c:IsSpellTrap() and c:IsSSetable()
end
function c26073001.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26073001.tffilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SET,nil,1,tp,LOCATION_DECK)
end
function c26073001.tfop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,c26073001.tffilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SSet(tp,tc)
	end
end