--Theriomachination
function c26074014.initial_effect(c)
	--double summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26074014,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c26074014.cost)
	e1:SetTarget(c26074014.target1)
	e1:SetOperation(c26074014.activate1)
	c:RegisterEffect(e1)
	--geminize + summon
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(26074014,1))
	e2:SetTarget(c26074014.target2)
	e2:SetOperation(c26074014.activate2)
	c:RegisterEffect(e2)
	--search
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(26074014,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetTarget(c26074014.target3)
	e3:SetOperation(c26074014.activate3)
	c:RegisterEffect(e3)
	--activate on discard
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26074014,3))
	e4:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DISCARD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,26074014)
	e4:SetTarget(c26074014.target4)
	c:RegisterEffect(e4)
end
function c26074014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	c26074014.check=true
	if chk==0 then return true end
end
function c26074014.filter1(c)
	return c:IsSummonable(true,nil) and c:IsType(TYPE_GEMINI)
end
function c26074014.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not c26074014.check then return false end
		c26074014.check=false   
		return Duel.IsExistingMatchingCard(c26074014.filter1,tp,LOCATION_HAND|LOCATION_MZONE,0,1,nil) and Duel.GetFlagEffect(tp,26074014)==0
	end
	Duel.RegisterFlagEffect(tp,26074014,RESET_PHASE|PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c26074014.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c26074014.filter1,tp,LOCATION_HAND|LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	local op=false
	if tc then
		if tc:IsOnField() then op=true end
		if op and Duel.Summon(tp,tc,true,nil)~=0 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c26074014.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_GEMINI) and not c:IsGeminiStatus()
end
function c26074014.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not c26074014.check then return false end
		c26074014.check=false   
		return Duel.IsExistingTarget(c26074014.filter2,tp,LOCATION_HAND|LOCATION_MZONE,0,1,nil) and Duel.GetFlagEffect(tp,26074114)==0
	end
	Duel.RegisterFlagEffect(tp,26074114,RESET_PHASE|PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c26074014.filter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c26074014.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and c26074014.filter2(tc) then
		tc:EnableGeminiStatus()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local tc=Duel.SelectMatchingCard(tp,Card.IsSummonable,tp,LOCATION_HAND|LOCATION_MZONE,0,0,1,nil,true):GetFirst()
		if tc then Duel.Summon(tp,tc,true,nil) end
	end
end

function c26074014.filter3(c)
	return c:IsSetCard(0x674) and c:IsAbleToHand()
end
function c26074014.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not c26074014.check then return false end
		c26074014.check=false
		return Duel.IsExistingMatchingCard(c26074014.filter3,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,26074214)==0
	end
	Duel.RegisterFlagEffect(tp,26074214,RESET_PHASE|PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26074014.activate3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26074014.filter3,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectReleaseGroupEx(tp,Card.IsLocation,0,1,nil,LOCATION_HAND)
		local tc=g:GetFirst()
		if tc then Duel.Release(g,REASON_EFFECT) end
	end
end
function c26074014.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	c26074014.check=true
	local tg1=c26074014.target1(e,tp,eg,ep,ev,re,r,rp,0)
	c26074014.check=true
	local tg2=c26074014.target2(e,tp,eg,ep,ev,re,r,rp,0)
	c26074014.check=true
	local tg3=c26074014.target3(e,tp,eg,ep,ev,re,r,rp,0)
	if chk==0 then return tg1 or tg2 or tg3 end
	e:SetCategory(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectEffect(tp,
		{tg1,aux.Stringid(26074014,0)},
		{tg2,aux.Stringid(26074014,1)},
		{tg3,aux.Stringid(26074014,2)}) 
	if op==1 then
		e:SetCategory(CATEGORY_SUMMON|CATEGORY_DRAW)
		c26074014.target1(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetOperation(c26074014.activate1)
	end
	if op==2 then
		e:SetCategory(CATEGORY_SUMMON)
		c26074014.target2(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetOperation(c26074014.activate2)
	end
	if op==3 then
		e:SetCategory(CATEGORY_TOHAND|CATEGORY_SEARCH)
		c26074014.target3(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetOperation(c26074014.activate3)
	end
end