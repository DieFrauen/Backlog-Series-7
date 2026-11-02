--Egos - Dementium
function c26071012.initial_effect(c)
	Ritual.AddProcGreater({handler=c,
		desc=aux.Stringid(26071012,0),
		filter=c26071012.rfilter,
		extrafil=c26071012.rextrafil,
		extratg=c26071012.rextra})
	--Fusion
	local e1=Fusion.CreateSummonEff({handler=c,
						fusfilter=c26071012.ffilter,
						desc=aux.Stringid(26071012,1),
						extrafil=c26071012.fextra,
						extratg=c26071012.fextratg)
	c:RegisterEffect(e1)
	
end
c26071012.listed_names={26071001}
function c26071012.rfilter(c)
	return c:IsCode(26071001)
end
function c26071012.rextrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetMatchingGroup(c26071012.rfilter,tp,LOCATION_GRAVE,0,nil)
end
function c26071012.rextra(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
function c26071012.fextratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,LOCATION_DECK|LOCATION_EXTRA)
end
function c26071012.ffilter(c)
	return c:IsCode(26071001) or c:ListsCode(26071001)
end
function c26071012.fxfilter(c,p,TYPE)
	return c:IsType(TYPE) and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsType,TYPE),p,0,LOCATION_MZONE|LOCATION_GRAVE,1,nil)
end
function c26071012.fextra(e,tp,mg)
	local g=Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsAbleToGrave),tp,LOCATION_DECK|LOCATION_EXTRA,0,nil,tp)
	fg=g:Filter(c26071012.fxfilter,nil,tp,TYPE_FUSION)
	rg=g:Filter(c26071012.fxfilter,nil,tp,TYPE_RITUAL)
	sg=g:Filter(c26071012.fxfilter,nil,tp,TYPE_SYNCHRO)
	xg=g:Filter(c26071012.fxfilter,nil,tp,TYPE_XYZ)
	pg=g:Filter(c26071012.fxfilter,nil,tp,TYPE_PENDULUM)
	lg=g:Filter(c26071012.fxfilter,nil,tp,TYPE_LINK)
	fg:Merge(rg);fg:Merge(sg);fg:Merge(xg);fg:Merge(pg);fg:Merge(lg);
	return fg,c26071012.fcheck
end
function c26071012.fcheck(tp,sg,fc)
	return sg:FilterCount(c26071012.dextra,nil,TYPE_FUSION)<2
	and sg:FilterCount(c26071012.dextra,nil,TYPE_RITUAL)<2
	and sg:FilterCount(c26071012.dextra,nil,TYPE_SYNCHRO)<2
	and sg:FilterCount(c26071012.dextra,nil,TYPE_XYZ)<2
	and sg:FilterCount(c26071012.dextra,nil,TYPE_PENDULUM)<2
	and sg:FilterCount(c26071012.dextra,nil,TYPE_LINK)<2
end
function c26071012.dextra(c,typ)
	return c:IsType(typ)
	and c:IsLocation(LOCATION_DECK|LOCATION_EXTRA)
	--and 
end