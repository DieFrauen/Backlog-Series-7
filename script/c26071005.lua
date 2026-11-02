--Egos - Dysphor
function c26071005.initial_effect(c)
	--Change its name to "Egos"
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetRange(LOCATION_MZONE|LOCATION_HAND|LOCATION_GRAVE)
	e0:SetValue(26071001)
	c:RegisterEffect(e0)
	Pendulum.AddProcedure(c)
	
end
c26071005.listed_names={26071001}
