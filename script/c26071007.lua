--Egos - Superbias
function c26071007.initial_effect(c)
	c:EnableReviveLimit()
	--Change its name to "Egos"
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetRange(LOCATION_MZONE|LOCATION_HAND|LOCATION_GRAVE)
	e0:SetValue(26071001)
	c:RegisterEffect(e0)
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,26071007)
	e1:SetCost(c26071007.thcost)
	e1:SetTarget(c26071007.thtg)
	e1:SetOperation(c26071007.thop)
	c:RegisterEffect(e1)
	
end
c26071007.listed_names={26071001}
function c26071007.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	Duel.ConfirmCards(1-tp,e:GetHandler())
end
function c26071007.thfilter(c)
	return ((c:ListsCode(26071001) and not c:IsType(TYPE_RITUAL)) or c:IsCode(26071001))
		 and c:IsAbleToHand()
end
function c26071007.rescon(sg,e,tp,mg)
	return sg:FilterCount(Card.IsCode,nil,26071001)==1 or #sg<2
end
function c26071007.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26071007.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
function c26071007.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c26071007.thfilter),tp,LOCATION_DECK|LOCATION_GRAVE,0,nil)
	if #g>0 then
		local sg=aux.SelectUnselectGroup(g,e,tp,1,2,c26071007.rescon,1,tp,HINTMSG_ATOHAND)
		if #sg>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
			local dg=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil,REASON_EFFECT)
			if #dg>0 then
				Duel.BreakEffect()
				Duel.SendtoGrave(dg,REASON_DISCARD|REASON_EFFECT)
			end
		end
	end
end