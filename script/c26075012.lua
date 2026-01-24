--Chaos Diffusion
function c26075012.initial_effect(c)
	--Fusion Summon 1 Fusion monster using materials from the hand
	local e1=Fusion.CreateSummonEff(c,aux.FilterBoolFunction(Card.IsType,TYPE_SPIRIT),c26075012.matfilter,c26075012.fextra,c26075012.extraop,nil,nil,nil,nil,nil,nil,nil,nil,nil,c26075012.extratg)
	e1:SetDescription(aux.Stringid(26075012,0))
	e1:SetCountLimit(1,26075012,EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--fusion from banish
	local fusparams = 
	{filter=aux.FilterBoolFunction(Card.IsSetCard,0x675),
	matfilter=aux.FALSE,
	extrafil=c26075012.fextra2,
	extraop=Fusion.ShuffleMaterial}
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26075012,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,{26075012,1})
	e2:SetCondition(function(e) return Duel.GetCurrentPhase()~=PHASE_DAMAGE end)
	e2:SetTarget(Fusion.SummonEffTG(fusparams))
	e2:SetOperation(Fusion.SummonEffOP(fusparams))
	c:RegisterEffect(e2)
end
c26075012.listed_series={0x675}
function c26075012.matfilter(c)
	return c:IsType(TYPE_SPIRIT)
	and (c:IsOnField() and c:IsAbleToHand()
	or c:IsAbleToDeck())
end
function c26075012.fextra(e,tp,mg)
	return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsAbleToDeck),tp,LOCATION_GRAVE,0,nil)--,c26075012.checkmat
end
function c26075012.extraop(e,tc,tp,sg)
	local th=sg:Filter(Card.IsLocation,nil,LOCATION_ONFIELD)
	local td=sg:Clone()
	td:Sub(th)
	if #th>0 then
		Duel.HintSelection(th)
		Duel.SendtoHand(th,nil,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		sg:Sub(th)
	end
	if #td>0 then
		Duel.HintSelection(td)
		Duel.SendtoDeck(td,nil,LOCATION_DECKSHF,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		sg:Sub(td)
	end
end
function c26075012.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_HAND|LOCATION_GRAVE)
end
function c26075012.fextra2(e,tp,mg)
	return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsFaceup,Card.IsAbleToDeck),tp,LOCATION_REMOVED,0,nil)
end