--Egos - Delirias
function c26071010.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,c26071010.filter,2,nil,c26071010.spcheck)
	--Change its name to "Egos"
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetRange(LOCATION_MZONE|LOCATION_EXTRA|LOCATION_GRAVE)
	e0:SetValue(26071001)
	c:RegisterEffect(e0)
	--use hidden link materials
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_EXTRA_MATERIAL)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(1,1)
	e1:SetOperation(c26071010.extracon)
	e1:SetValue(c26071010.extraval)
	c:RegisterEffect(e1)
end
c26071010.listed_names={26071001}
function c26071010.filter(c,lc,sumtype,tp)
	return not c:IsType(TYPE_TOKEN,lc,sumtype,tp)
end
function c26071010.spcheck(g,lc,tp)
	return g:CheckSameProperty(Card.GetCode,lc,SUMMON_TYPE_LINK,tp)
end
function c26071010.linkfilter(c)
	return c:IsCode(26071001) and c:IsCanBeLinkMaterial()
	and c:IsLocation(LOCATION_HAND)
end
function c26071010.extracon(c,e,tp,sg,mg,lc,og,chk)
	if not c26071010.curgroup then return true end
	local g=c26071010.curgroup:Filter(Card.IsLocation,nil,LOCATION_HAND)
	return #(sg&g)<2
end
function c26071010.extraval(chk,summon_type,e,...)
	if chk==0 then
		local tp,sc=...
		if summon_type~=SUMMON_TYPE_LINK or sc~=e:GetHandler() then
			return Group.CreateGroup()
		else
			c26071010.curgroup=Duel.GetMatchingGroup(c26071010.linkfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
			c26071010.curgroup:KeepAlive()
			return c26071010.curgroup
		end
	elseif chk==2 then
		if c26071010.curgroup then
			c26071010.curgroup:DeleteGroup()
		end
		c26071010.curgroup=nil
	end
end