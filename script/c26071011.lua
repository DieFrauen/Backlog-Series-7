--Egos - Megalomania
function c26071011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26071011,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCategory(0)
	--e1:SetCountLimit(1,26071011,EFFECT_COUNT_CODE_OATH)
	--e1:SetTarget(c26071011.target)
	--e1:SetOperation(c26071011.activate)
	c:RegisterEffect(e1)
	
end
c26071011.listed_names={26071001}
