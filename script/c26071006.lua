--Egos - Narcisus
function c26071006.initial_effect(c)
	c:EnableReviveLimit()
	--Fusion Summon procedure
	Fusion.AddProcMixRep(c,true,true,aux.FilterBoolFunctionEx(Card.IsCode,26071001),1,99,26071001,26071001)
	--Change its name to "Egos"
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetRange(LOCATION_MZONE|LOCATION_EXTRA|LOCATION_GRAVE)
	e0:SetValue(26071001)
	c:RegisterEffect(e0)
end
c26071006.listed_names={26071001}