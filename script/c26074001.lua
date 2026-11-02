--Theriomachine Sagitas
function c26074001.initial_effect(c)
	--summon & set with no tribute
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(26074001,3))
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SUMMON_PROC)
	e0:SetCondition(c26074001.ntcon)
	c:RegisterEffect(e0)
	--Gemini
	local e0a=Effect.CreateEffect(c)
	e0a:SetType(EFFECT_TYPE_SINGLE)
	e0a:SetCode(EFFECT_GEMINI_SUMMONABLE)
	c:RegisterEffect(e0a)
	local e0b=Effect.CreateEffect(c)
	e0b:SetType(EFFECT_TYPE_SINGLE)
	e0b:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0b:SetRange(LOCATION_MZONE)
	e0b:SetCode(EFFECT_ADD_TYPE)
	e0b:SetCondition(Gemini.NormalStatusCondition)
	e0b:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e0b)
	local e0c=e0b:Clone()
	e0c:SetCode(EFFECT_REMOVE_TYPE)
	e0c:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e0c)
	local e0c=e0a:Clone()
	e0c:SetValue(TYPE_TUNER)
	e0c:SetCondition(Gemini.EffectStatusCondition)
	c:RegisterEffect(e0c)
	--chain summoning
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26074001,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	--e1:SetCountLimit(1,id)
	e1:SetCondition(Gemini.EffectStatusCondition)
	e1:SetTarget(c26074001.target1)
	e1:SetOperation(c26074001.operation1)
	c:RegisterEffect(e1)
	--add to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26074001,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	--e2:SetCountLimit(1,id)
	e2:SetCondition(c26074001.condition2)
	e2:SetTarget(c26074001.target2)
	e2:SetOperation(c26074001.operation2)
	c:RegisterEffect(e2)
	--tribute to draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26074001,2))
	e3:SetCategory(CATEGORY_TOHAND|CATEGORY_RELEASE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_RELEASE)
	--e3:SetCountLimit(1,id)
	e3:SetTarget(c26074001.target3)
	e3:SetOperation(c26074001.operation3)
	c:RegisterEffect(e3)
	--tribute check
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCountLimit(1)
	e4:SetCondition(c26074001.regcon)
	e4:SetOperation(c26074001.regop)
	c:RegisterEffect(e4)
end
function c26074001.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c26074001.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=0
		local ce={Duel.IsPlayerAffectedByEffect(tp,EFFECT_SET_SUMMON_COUNT_LIMIT)}
		for _,te in ipairs(ce) do
			ct=math.max(ct,te:GetValue())
		end
		return ct<3
	end
end
function c26074001.operation1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(3)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function c26074001.tfilter(c)
	return c:IsType(TYPE_GEMINI) and c:IsFaceup()
end
function c26074001.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26074001.tfilter,1,nil) 
	and not eg:IsContains(e:GetHandler())
	and Gemini.EffectStatusCondition(e)
end
function c26074001.filter2(c)
	return c:IsType(TYPE_GEMINI) and c:IsAbleToHand()
end
function c26074001.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c26074001.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26074001.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c26074001.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c26074001.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsType(TYPE_GEMINI) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end

function c26074001.sendfilter(c)
	return c:IsType(TYPE_GEMINI)
end
function c26074001.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,Card.IsType,1,nil,TYPE_GEMINI) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c26074001.operation3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectReleaseGroupEx(tp,Card.IsType,1,1,nil,TYPE_GEMINI)
	if g and #g>0 then
		Duel.HintSelection(g)
		local rct=Duel.Release(g,REASON_EFFECT)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c26074001.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsTributeSummoned()
end
function c26074001.regop(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		c:EnableGeminiStatus()
		c:RegisterFlagEffect(0,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,64)
		Duel.RaiseSingleEvent(c,EVENT_SUMMON_SUCCESS,e,0,tp,tp,SUMMON_TYPE_NORMAL)
end