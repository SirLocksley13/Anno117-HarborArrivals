local HarborArrivals = {}

HarborArrivals.VERSION = "1.0.0"
HarborArrivals.SHORT_WARNING_STORYLINE_GUID = 2099911
HarborArrivals.STORYLINE_GUID = 2099901
HarborArrivals.scanActive = false
HarborArrivals.scanStage = "idle"
HarborArrivals.scanTicks = 0
HarborArrivals.tradeRouteOpenedByUs = false
HarborArrivals.filterPopupOpenedByUs = false
HarborArrivals.context = nil
HarborArrivals.routes = {}
HarborArrivals.failureReason = nil
HarborArrivals.pendingOpen = false
HarborArrivals.opening = false
HarborArrivals.openTicks = 0
HarborArrivals.reportText = nil
HarborArrivals.reportApplied = false
HarborArrivals.motionSampleStartPlayTime = nil
HarborArrivals.motionSampleMidPlayTime = nil
HarborArrivals.ARRIVAL_RADIUS = 30
HarborArrivals.SERVICE_EXIT_RADIUS = 60
HarborArrivals.CARGO_PROBE_RADIUS = 120
HarborArrivals.CARGO_SERVICE_START_RADIUS = 55
HarborArrivals.CARGO_PROBE_INTERVAL_MS = 250
-- Display-only onboard cargo reads are separate from the near-harbor transaction probe.
-- They refresh slowly for currently enumerated ships so the dashboard can show what a ship carries
-- without changing service/ETA/queue classification.
HarborArrivals.ONBOARD_CARGO_REFRESH_INTERVAL_MS = 5000
HarborArrivals.ONBOARD_CARGO_MAX_GOODS = 4
HarborArrivals.ONBOARD_CARGO_READ_BUDGET_PER_REPORT = 4
HarborArrivals.LIVE_REFRESH_INTERVAL_MS = 1000
HarborArrivals.AUTO_ETA_SAMPLE_INTERVAL_MS = 850
HarborArrivals.AUTO_ETA_CONFIRM_INTERVAL_MS = 5000
HarborArrivals.AUTO_ETA_CONFIRM_REQUIRED = 3
HarborArrivals.AUTO_ETA_CONFIRM_WINDOW_MS = 15000
HarborArrivals.NEAR_ETA_DISTANCE = 150
HarborArrivals.NEAR_ETA_MIN_ALIGNMENT = 0.75
HarborArrivals.NEAR_ETA_CONFIRM_REQUIRED = 1
HarborArrivals.NEAR_ETA_CONFIRM_WINDOW_MS = 5000
HarborArrivals.CARGO_PROBE_MAX_SLOT = 31
HarborArrivals.QUEUE_SAMPLE_INTERVAL_MS = 5000
HarborArrivals.QUEUE_MAX_DISPLACEMENT = 2.0
HarborArrivals.QUEUE_RESUME_SUSTAINED_SAMPLES = 3
HarborArrivals.LONG_BLOCKER_MS = 300000
HarborArrivals.SLOW_LOADING_RECENT_MS = 300000
HarborArrivals.TRANSACTION_STATE_TTL_MS = 5000
HarborArrivals.ETA_MIN_ALIGNMENT = 0.50
-- Initial Open scans require stronger harbor alignment before locking ETA.
-- Sustained later auto-confirmation remains unchanged and can acquire the ETA afterward.
HarborArrivals.INITIAL_ETA_MIN_ALIGNMENT = 0.75
HarborArrivals.ETA_STABILITY_MAX_REL_CHANGE = 0.35
HarborArrivals.ETA_RECENT_WEIGHT = 0.65
-- Diagnostic-only approach milestones. These do not alter ETA or classification.
-- Long-distance thresholds localize where post-lock acceleration/deceleration begins.
HarborArrivals.ETA_APPROACH_MILESTONES = { 1250, 1000, 750, 500, 250, 120, 90, 60, 30 }
HarborArrivals.serviceWatch = {}
HarborArrivals.serviceHistory = {}
HarborArrivals.onboardCargoCache = {}
HarborArrivals.onboardCargoReadsThisReport = 0
HarborArrivals.lastServiceTickPlayTime = nil
HarborArrivals.etaPredictions = {}
HarborArrivals.etaValidationHistory = { arrivalZone = nil, service = nil, queueAdjustedArrivalZone = nil, queueAdjustedService = nil }
HarborArrivals.movementTypeInfoSeen = {}
HarborArrivals.gameObjectTypeInfoLogged = false
HarborArrivals.manualShipCandidates = {}
HarborArrivals.manualShipResults = {}
HarborArrivals.manualShipsAtHarbor = {}
HarborArrivals.manualShipOwner = nil
HarborArrivals.liveDashboardActive = false
HarborArrivals.lastLiveRefreshMs = nil
HarborArrivals.lastAppliedReportText = nil
HarborArrivals.lastValidationSummarySignature = nil
HarborArrivals.panelVisible = false
HarborArrivals.panelHeaderText = ""
HarborArrivals.panelDescriptionText = ""
HarborArrivals.parchmentJumpEntries = {}
HarborArrivals.shortWarningOpening = false
HarborArrivals.shortWarningApplied = false
HarborArrivals.shortWarningTicks = 0
HarborArrivals.shortWarningReason = nil
HarborArrivals.uiLanguage = "en"
HarborArrivals.languageDetected = false
HarborArrivals.LANGUAGE_LINE_ID = 2006999900

-- v1.0.0: public release; all user-visible Lua-generated dashboard/warning text is localized.
-- Product/ship/route/goods names remain live game strings. English is the safe fallback.
HarborArrivals.STRINGS = {
  en = {
    harbor_arrivals = "HARBOR ARRIVALS",
    harbor_status = "HARBOR STATUS",
    at_harbor = "At harbor",
    waiting = "Waiting",
    incoming = "Incoming",
    eta_stabilizing = "ETA stabilizing",
    eta_stabilizing_heading = "ETA STABILIZING",
    next_arrivals = "NEXT ARRIVALS",
    no_confirmed_arrivals = "No confirmed arrivals",
    updates_live = "Updates live while open",
    harbor_now = "HARBOR NOW",
    waiting_for_harbor = "WAITING FOR HARBOR",
    ships_without_arrival_time = "SHIPS WITHOUT CURRENT ARRIVAL TIME",
    outbound = "OUTBOUND",
    paused_waiting = "PAUSED / WAITING",
    stopped_waiting = "STOPPED / WAITING",
    direction_unclear = "DIRECTION UNCLEAR",
    other = "OTHER",
    route = "Route",
    on_board = "On board",
    empty = "empty",
    more = "more",
    good = "Good",
    picking_up = "Picking up",
    unloading = "Unloading",
    loading = "Loading",
    unloading_loading = "Unloading + loading",
    servicing = "Servicing",
    manual = "manual",
    manually_directed = "Manually directed",
    manually_directed_lower = "manually directed",
    selected = "Selected",
    selected_harbor = "Selected harbor",
    ship = "Ship",
    unnamed_ship = "Unnamed ship",
    waiting_word = "waiting",
    numbered_jump_help = "▶ Numbered ships: use Parchment Controls - Entry 1–9 to jump",
    no_object_selected = "NO OBJECT SELECTED",
    select_harbor_retry = "Select a harbor/trading post, then press Ctrl+Alt+H again.",
    ship_selected_title = "SHIP SELECTED — SELECT HARBOR / TRADING POST",
    ship_selected_explain = "Harbor Arrivals needs the harbor object's position as the ETA reference.",
    select_harbor_itself_retry = "Select the harbor/trading post itself, then press Ctrl+Alt+H again.",
    no_harbor_selected = "NO HARBOR / TRADING POST SELECTED",
    no_harbor_position = "The island is known, but no harbor position is available for ETA calculations.",
    route_scan_failed = "TARGETED ROUTE SCAN DID NOT COMPLETE",
    stage_reason = "Stage/reason",
    send_log = "Please send the logfile; search marker",
    harbor_not_selected = "Harbor not selected",
    no_report_data = "HARBOR ARRIVALS — no report data",
    harbor_word = "Harbor",
    state_at_harbor_servicing = "At harbor / servicing",
    state_blocking_queue = "At harbor — blocking queue",
    state_slow_loading_blocking = "At harbor — slow loading / blocking queue",
    state_slow_transfer_blocking = "At harbor — slow transfer / blocking queue",
    state_outbound_departed = "Outbound / departed",
    state_leaving_harbor = "Leaving harbor",
    state_possibly_inbound_turning = "Possibly inbound / turning",
    state_waiting_near_harbor = "Waiting near harbor",
    state_cargo_repositioned = "Cargo repositioned",
    state_active = "Active",
    state_live = "Live",
    state_not_assigned = "Not assigned",
    state_inbound = "Inbound",
  },
  de = {
    harbor_arrivals = "HAFENANKÜNFTE",
    harbor_status = "HAFENSTATUS",
    at_harbor = "Im Hafen",
    waiting = "Wartend",
    incoming = "Ankommend",
    eta_stabilizing = "ETA wird stabilisiert",
    eta_stabilizing_heading = "ETA WIRD STABILISIERT",
    next_arrivals = "NÄCHSTE ANKÜNFTE",
    no_confirmed_arrivals = "Keine bestätigten Ankünfte",
    updates_live = "Wird bei geöffnetem Fenster live aktualisiert",
    harbor_now = "JETZT IM HAFEN",
    waiting_for_harbor = "WARTEN AUF DEN HAFEN",
    ships_without_arrival_time = "SCHIFFE OHNE AKTUELLE ANKUNFTSZEIT",
    outbound = "AUSLAUFEND",
    paused_waiting = "PAUSIERT / WARTEND",
    stopped_waiting = "ANGEHALTEN / WARTEND",
    direction_unclear = "RICHTUNG UNKLAR",
    other = "SONSTIGE",
    route = "Route",
    on_board = "An Bord",
    empty = "leer",
    more = "weitere",
    good = "Ware",
    picking_up = "Geladen",
    unloading = "Entladen",
    loading = "Beladen",
    unloading_loading = "Entladen + beladen",
    servicing = "Abfertigung",
    manual = "manuell",
    manually_directed = "Manuell gesteuert",
    manually_directed_lower = "manuell gesteuert",
    selected = "Ausgewählt",
    selected_harbor = "Ausgewählter Hafen",
    ship = "Schiff",
    unnamed_ship = "Unbenanntes Schiff",
    waiting_word = "wartend",
    numbered_jump_help = "▶ Nummerierte Schiffe: Parchment-Steuerung - Eintrag 1–9 zum Springen verwenden",
    no_object_selected = "KEIN OBJEKT AUSGEWÄHLT",
    select_harbor_retry = "Wähle einen Hafen/Handelsposten aus und drücke erneut Ctrl+Alt+H.",
    ship_selected_title = "SCHIFF AUSGEWÄHLT — HAFEN / HANDELSPOSTEN AUSWÄHLEN",
    ship_selected_explain = "Harbor Arrivals benötigt die Position des Hafens als Referenz für die ETA-Berechnung.",
    select_harbor_itself_retry = "Wähle den Hafen/Handelsposten selbst aus und drücke erneut Ctrl+Alt+H.",
    no_harbor_selected = "KEIN HAFEN / HANDELSPOSTEN AUSGEWÄHLT",
    no_harbor_position = "Die Insel ist bekannt, aber für die ETA-Berechnung ist keine Hafenposition verfügbar.",
    route_scan_failed = "ZIELGERICHTETER ROUTENSCAN NICHT ABGESCHLOSSEN",
    stage_reason = "Phase/Grund",
    send_log = "Bitte sende die Logdatei; Suchmarker",
    harbor_not_selected = "Hafen nicht ausgewählt",
    no_report_data = "HAFENANKÜNFTE — keine Berichtsdaten",
    harbor_word = "Hafen",
    state_at_harbor_servicing = "Im Hafen / Abfertigung",
    state_blocking_queue = "Im Hafen — blockiert die Warteschlange",
    state_slow_loading_blocking = "Im Hafen — langsames Beladen / blockiert Warteschlange",
    state_slow_transfer_blocking = "Im Hafen — langsamer Umschlag / blockiert Warteschlange",
    state_outbound_departed = "Auslaufend / abgefahren",
    state_leaving_harbor = "Verlässt den Hafen",
    state_possibly_inbound_turning = "Möglicherweise ankommend / wendet",
    state_waiting_near_harbor = "Wartet nahe dem Hafen",
    state_cargo_repositioned = "Ladung umgelagert",
    state_active = "Aktiv",
    state_live = "Live",
    state_not_assigned = "Nicht zugewiesen",
    state_inbound = "Ankommend",
  },
  fr = {
    harbor_arrivals = "ARRIVÉES AU PORT",
    harbor_status = "ÉTAT DU PORT",
    at_harbor = "Au port",
    waiting = "En attente",
    incoming = "En approche",
    eta_stabilizing = "ETA en cours de stabilisation",
    eta_stabilizing_heading = "ETA EN COURS DE STABILISATION",
    next_arrivals = "PROCHAINES ARRIVÉES",
    no_confirmed_arrivals = "Aucune arrivée confirmée",
    updates_live = "Actualisation en direct tant que la fenêtre est ouverte",
    harbor_now = "AU PORT MAINTENANT",
    waiting_for_harbor = "EN ATTENTE DU PORT",
    ships_without_arrival_time = "NAVIRES SANS HEURE D’ARRIVÉE ACTUELLE",
    outbound = "EN PARTANCE",
    paused_waiting = "EN PAUSE / EN ATTENTE",
    stopped_waiting = "À L’ARRÊT / EN ATTENTE",
    direction_unclear = "DIRECTION INCERTAINE",
    other = "AUTRES",
    route = "Route",
    on_board = "À bord",
    empty = "vide",
    more = "de plus",
    good = "Marchandise",
    picking_up = "Chargement",
    unloading = "Déchargement",
    loading = "Chargement",
    unloading_loading = "Déchargement + chargement",
    servicing = "Opérations en cours",
    manual = "manuel",
    manually_directed = "Dirigé manuellement",
    manually_directed_lower = "dirigé manuellement",
    selected = "Sélectionné",
    selected_harbor = "Port sélectionné",
    ship = "Navire",
    unnamed_ship = "Navire sans nom",
    waiting_word = "en attente",
    numbered_jump_help = "▶ Navires numérotés : utilisez Commandes du parchemin - Entrée 1–9 pour y accéder",
    no_object_selected = "AUCUN OBJET SÉLECTIONNÉ",
    select_harbor_retry = "Sélectionnez un port/comptoir commercial, puis appuyez de nouveau sur Ctrl+Alt+H.",
    ship_selected_title = "NAVIRE SÉLECTIONNÉ — SÉLECTIONNEZ LE PORT / COMPTOIR COMMERCIAL",
    ship_selected_explain = "Harbor Arrivals a besoin de la position du port comme référence pour le calcul de l’ETA.",
    select_harbor_itself_retry = "Sélectionnez le port/comptoir commercial lui-même, puis appuyez de nouveau sur Ctrl+Alt+H.",
    no_harbor_selected = "AUCUN PORT / COMPTOIR COMMERCIAL SÉLECTIONNÉ",
    no_harbor_position = "L’île est connue, mais aucune position de port n’est disponible pour le calcul de l’ETA.",
    route_scan_failed = "L’ANALYSE CIBLÉE DES ROUTES N’A PAS ABOUTI",
    stage_reason = "Étape/raison",
    send_log = "Veuillez envoyer le fichier journal ; marqueur de recherche",
    harbor_not_selected = "Port non sélectionné",
    no_report_data = "ARRIVÉES AU PORT — aucune donnée de rapport",
    harbor_word = "Port",
    state_at_harbor_servicing = "Au port / opérations en cours",
    state_blocking_queue = "Au port — bloque la file d’attente",
    state_slow_loading_blocking = "Au port — chargement lent / bloque la file d’attente",
    state_slow_transfer_blocking = "Au port — transfert lent / bloque la file d’attente",
    state_outbound_departed = "En partance / parti",
    state_leaving_harbor = "Quitte le port",
    state_possibly_inbound_turning = "Peut-être en approche / en virage",
    state_waiting_near_harbor = "En attente près du port",
    state_cargo_repositioned = "Cargaison réorganisée",
    state_active = "Actif",
    state_live = "En direct",
    state_not_assigned = "Non affecté",
    state_inbound = "En approche",
  },
}

-- Static configuration facts copied from the current Anno 117 assets.xml only for diagnostics.
-- ETA continues to use live measured movement; these values are NOT used to force a travel speed.
HarborArrivals.HULL_INFO = {
  [37222] = { name = "Penteconter", baseSpeed = 4.77, baseHealth = 500 },
  [37223] = { name = "Trireme", baseSpeed = 4.3, baseHealth = 1250 },
}
HarborArrivals.MODULE_INFO = {
  [31647] = { name = "Mast", note = "wind-positive modifier" },
  [31648] = { name = "Rows", note = "wind-negative modifier" },
  [31649] = { name = "Hull", note = "+35% health / -5% base speed", baseSpeedFactor = 0.95 },
}

local TAG = "[Harbor Arrivals 1.0.0]"
-- Protected runtime architecture. Release cleanup changes metadata, documentation,
-- and startup diagnostics only; ETA, queue, cargo, route-scan, manual-ship, popup,
-- parchment navigation, and right-panel behavior remain unchanged.

-- Deep discovery diagnostics are intentionally disabled in normal builds.
-- Set this to true only for bounded API investigations; normal ETA/queue/service logging remains active.
local DEEP_DIAGNOSTICS = false

local function log(message)
  print(TAG .. " " .. tostring(message))
end

local function safeCall(fn)
  local ok, value = pcall(fn)
  if ok then return value end
  return nil
end

local function safeGet(object, key)
  if object == nil then return nil end
  return safeCall(function() return object[key] end)
end

local function trim(value)
  if value == nil then return nil end
  local text = tostring(value)
  text = text:gsub("^%s+", ""):gsub("%s+$", "")
  if text == "" or text == "nil" then return nil end
  return text
end

local function normalize(value)
  local text = trim(value)
  if text == nil then return nil end
  return string.lower(text:gsub("%s+", " "))
end

function HarborArrivals._ResolveLanguageFromLocalizedText(text)
  local raw = trim(text)
  if raw == nil then return nil end
  if raw == "HAFENANKÜNFTE - wird geladen..." then return "de" end
  if raw == "ARRIVÉES AU PORT - chargement..." then return "fr" end
  if raw == "HARBOR ARRIVALS - loading..." then return "en" end
  return nil
end

function HarborArrivals:_DetectUILanguage(candidateText)
  local language = self._ResolveLanguageFromLocalizedText(candidateText)
  local source = language ~= nil and "popup-marker" or nil

  if language == nil then
    local localized = safeCall(function()
      local manager = Text and Text.get and Text.get() or nil
      if manager == nil or rdsdk == nil or rdsdk.TextId == nil then return nil end
      -- UI Lab runtime proved rdsdk.TextId(numeric LineId) + CTextManager:GetText(TextId).
      -- Do not type-gate rdsdk.TextId: native callable tables may implement __call.
      local textId = rdsdk.TextId(self.LANGUAGE_LINE_ID)
      return manager:GetText(textId)
    end)
    language = self._ResolveLanguageFromLocalizedText(localized)
    if language ~= nil then source = "text-manager" end
  end

  if language ~= nil then
    local changed = tostring(self.uiLanguage or "") ~= tostring(language)
    self.uiLanguage = language
    self.languageDetected = true
    if changed or self.languageLogged ~= true then
      self.languageLogged = true
      log("LOCALIZATION | language=" .. tostring(language) .. " | source=" .. tostring(source or "unknown"))
    end
  elseif self.uiLanguage == nil then
    self.uiLanguage = "en"
  end
  return tostring(self.uiLanguage or "en")
end

function HarborArrivals:_T(key)
  local language = tostring(self.uiLanguage or "en")
  local languageTable = self.STRINGS[language] or self.STRINGS.en or {}
  local englishTable = self.STRINGS.en or {}
  local value = languageTable[key]
  if value == nil then value = englishTable[key] end
  if value == nil then return tostring(key or "") end
  return tostring(value)
end

function HarborArrivals:_FormatHarborHeader(islandName)
  local island = tostring(islandName or self:_T("selected"))
  if tostring(self.uiLanguage or "en") == "de" then
    return self:_T("harbor_word") .. " " .. island
  elseif tostring(self.uiLanguage or "en") == "fr" then
    return self:_T("harbor_word") .. " de " .. island
  end
  return island .. " " .. self:_T("harbor_word")
end

function HarborArrivals:_DisplayState(state)
  local text = tostring(state or "")
  local map = {
    ["AT HARBOR / SERVICING"] = "state_at_harbor_servicing",
    ["AT HARBOR — BLOCKING QUEUE"] = "state_blocking_queue",
    ["AT HARBOR — SLOW LOADING / BLOCKING QUEUE"] = "state_slow_loading_blocking",
    ["AT HARBOR — SLOW TRANSFER / BLOCKING QUEUE"] = "state_slow_transfer_blocking",
    ["OUTBOUND / DEPARTED"] = "state_outbound_departed",
    ["LEAVING HARBOR"] = "state_leaving_harbor",
    ["POSSIBLY INBOUND / TURNING"] = "state_possibly_inbound_turning",
    ["WAITING NEAR HARBOR"] = "state_waiting_near_harbor",
    ["CARGO REPOSITIONED"] = "state_cargo_repositioned",
    ["ACTIVE"] = "state_active",
    ["LIVE"] = "state_live",
    ["NOT ASSIGNED"] = "state_not_assigned",
    ["INBOUND"] = "state_inbound",
    ["OUTBOUND"] = "outbound",
    ["PAUSED / WAITING"] = "paused_waiting",
    ["STOPPED / WAITING"] = "stopped_waiting",
    ["DIRECTION UNCLEAR"] = "direction_unclear",
    ["UNCLEAR"] = "direction_unclear",
    ["WAITING FOR HARBOR"] = "waiting_for_harbor",
    ["ETA STABILIZING"] = "eta_stabilizing_heading",
    ["UNLOADING"] = "unloading",
    ["LOADING"] = "loading",
    ["UNLOADING + LOADING"] = "unloading_loading",
    ["SERVICING"] = "servicing",
    ["OTHER"] = "other",
  }
  local key = map[text]
  if key ~= nil then return self:_T(key) end
  return text
end

function HarborArrivals:_GroupLabel(groupName)
  local map = {
    ["OUTBOUND"] = "outbound",
    ["PAUSED / WAITING"] = "paused_waiting",
    ["STOPPED / WAITING"] = "stopped_waiting",
    ["DIRECTION UNCLEAR"] = "direction_unclear",
    ["OTHER"] = "other",
  }
  return self:_T(map[tostring(groupName)] or "other")
end

function HarborArrivals:_EmptyCargoLine()
  return self:_T("on_board") .. ": " .. self:_T("empty")
end

-- Pure queue-state helper kept separate from ETA logic. A short movement burst while
-- a ship is already queued is treated as repositioning. A real queue exit requires
-- sustained movement, entry into the arrival zone, or leaving the approach zone.
function HarborArrivals._ClassifyQueueSample(queueSuspected, harborBlockerCount, displacement, distance, movingStreak)
  local streak = tonumber(movingStreak) or 0
  local d = tonumber(distance)
  local move = tonumber(displacement)
  local blockers = tonumber(harborBlockerCount) or 0

  if queueSuspected then
    if d ~= nil and d <= HarborArrivals.ARRIVAL_RADIUS then
      return "RESUME_SERVICE", streak
    end
    if d ~= nil and d > HarborArrivals.CARGO_PROBE_RADIUS then
      return "RESUME_LEFT_APPROACH", streak
    end
    if move ~= nil and move <= HarborArrivals.QUEUE_MAX_DISPLACEMENT then
      return "WAITING", 0
    end
    if move ~= nil and move > HarborArrivals.QUEUE_MAX_DISPLACEMENT then
      streak = streak + 1
      if streak >= HarborArrivals.QUEUE_RESUME_SUSTAINED_SAMPLES then
        return "RESUME", streak
      end
      return "REPOSITIONING", streak
    end
    return "WAITING", 0
  end

  if d ~= nil and d > HarborArrivals.ARRIVAL_RADIUS and d <= HarborArrivals.CARGO_PROBE_RADIUS
    and blockers > 0 and move ~= nil and move <= HarborArrivals.QUEUE_MAX_DISPLACEMENT
  then
    return "SUSPECT", 0
  end
  return "NONE", 0
end

function HarborArrivals._LongBlockerState(occupiedMs, waitingShips, lastCargoState, lastCargoAgeMs)
  local occupied = tonumber(occupiedMs) or 0
  local waiters = tonumber(waitingShips) or 0
  if occupied < HarborArrivals.LONG_BLOCKER_MS or waiters <= 0 then return nil end
  local age = tonumber(lastCargoAgeMs)
  if tostring(lastCargoState) == "LOADING" and age ~= nil and age <= HarborArrivals.SLOW_LOADING_RECENT_MS then
    return "AT HARBOR — SLOW LOADING / BLOCKING QUEUE"
  end
  if tostring(lastCargoState) == "UNLOADING + LOADING" and age ~= nil and age <= HarborArrivals.SLOW_LOADING_RECENT_MS then
    return "AT HARBOR — SLOW TRANSFER / BLOCKING QUEUE"
  end
  return "AT HARBOR — BLOCKING QUEUE"
end

function HarborArrivals._ReportSection(state, etaSeconds, bucket)
  if bucket ~= "arrival" then return "other" end
  local text = tostring(state or "")
  if etaSeconds == 0 or text == "WAITING NEAR HARBOR" or string.find(text, "BLOCKING QUEUE", 1, true) ~= nil
    or string.find(text, "AT HARBOR", 1, true) ~= nil or string.find(text, "SERVICING", 1, true) ~= nil
  then
    return "harbor"
  end
  return "travel"
end

-- Pure player-view helper. The original Open-scan classification is only a
-- snapshot; watcher and locked-prediction state are authoritative afterward.
function HarborArrivals._LiveReportState(snapshotArrival, watch, prediction, now)
  local snapshot = type(snapshotArrival) == "table" and snapshotArrival or {}
  local w = type(watch) == "table" and watch or {}
  local p = type(prediction) == "table" and prediction or nil

  if w.inside == true then
    local state = w.transactionState ~= nil and ("SERVICING / " .. tostring(w.transactionState)) or "AT HARBOR / SERVICING"
    return { section = "harbor", state = state, etaSeconds = 0 }
  end

  if w.queueSuspected == true then
    return { section = "waiting", state = "WAITING FOR HARBOR", etaSeconds = nil }
  end

  if p ~= nil then
    local arrivalAt = tonumber(p.predictedArrivalAtMs)
    if arrivalAt == nil and type(p.predictedAtMs) == "number" and type(p.predictedEtaSeconds) == "number" then
      arrivalAt = p.predictedAtMs + p.predictedEtaSeconds * 1000
    end
    local remaining = nil
    if type(arrivalAt) == "number" and type(now) == "number" then
      remaining = math.max(0, (arrivalAt - now) / 1000)
    else
      remaining = tonumber(p.predictedEtaSeconds)
    end
    return { section = "travel", state = "INBOUND", etaSeconds = remaining }
  end

  if type(w.autoEtaConfirmStartMs) == "number" then
    return { section = "stabilizing", state = "ETA STABILIZING", etaSeconds = nil }
  end

  local staleSnapshot = type(w.lastServiceExitMs) == "number"
  if staleSnapshot and type(snapshot.capturedAtMs) == "number" then
    staleSnapshot = w.lastServiceExitMs >= snapshot.capturedAtMs
  end
  if staleSnapshot then
    return { section = "other", state = "OUTBOUND / DEPARTED", etaSeconds = nil }
  end

  if snapshot.bucket == "arrival" and snapshot.etaSeconds == 0 then
    return { section = "harbor", state = tostring(snapshot.state or "AT HARBOR / SERVICING"), etaSeconds = 0 }
  end
  if snapshot.bucket == "arrival" and type(snapshot.etaSeconds) ~= "number" then
    return { section = "stabilizing", state = "ETA STABILIZING", etaSeconds = nil }
  end

  return { section = "other", state = tostring(snapshot.state or "OTHER"), etaSeconds = nil }
end

-- Pure ownership/cadence helper for the live dashboard. It must never overwrite
-- another TextPopup that replaces the Harbor Arrivals parchment.
function HarborArrivals._LiveRefreshDecision(active, currentText, ownedText, now, lastRefreshMs, intervalMs)
  if active ~= true then return "STOP" end
  if tostring(currentText) ~= tostring(ownedText) then return "STOP" end
  local n = tonumber(now)
  local last = tonumber(lastRefreshMs)
  local interval = tonumber(intervalMs) or 1000
  if n ~= nil and last ~= nil and n - last < interval then return "WAIT" end
  return "REFRESH"
end

local function getSelectionObject()
  local selected = safeCall(function()
    return ts and ts.Selection and ts.Selection.Object or nil
  end)
  if selected ~= nil then return selected end
  return safeCall(function()
    return Selection and Selection.Object or nil
  end)
end

local function getCurrentArea()
  local area = safeCall(function()
    return ts and ts.Area and ts.Area.Current or nil
  end)
  if area ~= nil then return area end
  return safeCall(function()
    return Area and Area.Current or nil
  end)
end

local function getCurrentSelectedArea()
  local area = safeCall(function()
    return ts and ts.Area and ts.Area.CurrentSelectedArea or nil
  end)
  if area ~= nil then return area end
  return safeCall(function()
    return Area and Area.CurrentSelectedArea or nil
  end)
end

local function getAreaID(area)
  if area == nil then return nil end
  local id = safeGet(area, "ID") or safeGet(area, "AreaID") or safeGet(area, "GUID")
  if id ~= nil then return id end
  return safeCall(function() return area:GetID() end)
end

local function readAreaCityName(area)
  if area == nil then return nil end
  local value = trim(safeGet(area, "CityName"))
  if value ~= nil then return value end
  return trim(safeCall(function() return area:GetCityName() end))
end

local function getVectorCoordinates(position)
  if position == nil then return nil, nil, nil end
  local x = safeGet(position, "X")
  if type(x) ~= "number" then x = safeGet(position, "x") end
  local y = safeGet(position, "Y")
  if type(y) ~= "number" then y = safeGet(position, "y") end
  local z = safeGet(position, "Z")
  if type(z) ~= "number" then z = safeGet(position, "z") end
  if type(x) ~= "number" then x = nil end
  if type(y) ~= "number" then y = nil end
  if type(z) ~= "number" then z = nil end
  return x, y, z
end

local function readNameableName(object)
  return trim(safeGet(safeGet(object, "Nameable"), "Name"))
end

-- Harbor Arrivals needs the harbor/trading-post object's position as its reference point.
-- Important: Anno exposes generic property proxies on building selections too. v0.1.17
-- treated those proxies as proof of a ship and therefore falsely rejected the real Calypsis
-- trading post (GUID 3406). Only reject immediately when the selected asset GUID is one of
-- the ship hulls we have already proven. A second, stronger check runs after route harvest
-- and compares the selected object ID with the live assigned ship IDs.
local function selectionLooksLikeShip(object)
  if object == nil then return false end
  local guid = safeGet(object, "GUID")
  if type(guid) == "number" and HarborArrivals.HULL_INFO[guid] ~= nil then
    return true
  end
  return false
end

local function selectionMatchesHarvestedShip(context, routes)
  if context == nil or context.selectionID == nil then return false, nil end
  local selectedID = tostring(context.selectionID)
  for _, route in ipairs(routes or {}) do
    for _, ship in ipairs(route.ships or {}) do
      local shipID = ship.idText or safeGet(ship.object, "ID")
      if shipID ~= nil and tostring(shipID) == selectedID then
        return true, ship
      end
    end
  end
  return false, nil
end

local function readSelectionContext()
  local selected = getSelectionObject()
  if selected == nil then return nil, "no-object-selected" end

  local objectArea = safeGet(selected, "Area")
  local selectedArea = getCurrentSelectedArea()
  local currentArea = getCurrentArea()
  local islandName = readAreaCityName(objectArea)
    or readAreaCityName(selectedArea)
    or readAreaCityName(currentArea)

  local x, y, z = getVectorCoordinates(safeGet(selected, "Position"))
  local context = {
    selectionName = readNameableName(selected) or trim(safeGet(selected, "Name")) or "object",
    selectionGUID = safeGet(selected, "GUID"),
    selectionID = safeGet(selected, "ID"),
    rawAreaID = safeGet(selected, "AreaID") or safeGet(selected, "IslandID"),
    islandAreaID = getAreaID(objectArea) or getAreaID(selectedArea) or getAreaID(currentArea),
    islandName = islandName,
    harborX = x,
    harborY = y,
    harborZ = z,
  }

  if selectionLooksLikeShip(selected) then
    return context, "ship-selected-select-harbor"
  end
  -- Runtime can leave a pseudo/area selection available after the actual harbor
  -- object is no longer selected. In that case the island can still resolve but
  -- Position is nil. Harbor Arrivals must not start a route scan without the
  -- harbor reference coordinates required by all distance/ETA calculations.
  if x == nil or z == nil then
    return context, "harbor-position-unavailable"
  end
  if islandName == nil then
    return context, "island-name-unavailable"
  end
  return context, nil
end

local function getTradeRouteParts()
  local scene = safeCall(function() return ui and ui.Scenes and ui.Scenes.TradeRoute or nil end)
  local overview = safeGet(scene, "TradeOverview")
  local rows = safeGet(safeGet(overview, "OverviewListData"), "ArrayData")
  local filter = safeGet(overview, "FilterData")
  local islandList = safeGet(filter, "IslandListData")
  local buttons = safeGet(islandList, "IslandListData")
  local panelOpen = safeGet(overview, "IsPanelOpen")
  return scene, overview, rows, filter, islandList, buttons, panelOpen
end

local function countOverviewRows(rows)
  if rows == nil then return 0 end
  local count = 0
  local seenAny = false
  local emptyTail = 0
  for i = 0, 511 do
    local item = safeCall(function() return rows[i] end)
    if item ~= nil and not string.find(tostring(item), "weak null", 1, true) then
      count = count + 1
      seenAny = true
      emptyTail = 0
    elseif seenAny then
      emptyTail = emptyTail + 1
    end
    if seenAny and emptyTail >= 16 then break end
  end
  return count
end

local function expandCollapsedGroups(rows)
  if rows == nil then return 0 end
  local expanded = 0
  local seenAny = false
  local emptyTail = 0
  for i = 0, 127 do
    local item = safeCall(function() return rows[i] end)
    if item ~= nil and not string.find(tostring(item), "weak null", 1, true) then
      seenAny = true
      emptyTail = 0
      local isOpen = safeGet(item, "IsGroupOpen")
      local buttonData = safeGet(item, "ButtonData")
      if type(isOpen) == "boolean" and buttonData ~= nil and isOpen == false then
        local fn = safeGet(buttonData, "PrimaryButtonPressed")
        if type(fn) == "function" then
          local ok, result = pcall(function() return buttonData:PrimaryButtonPressed() end)
          log("TARGET FILTER GROUP EXPAND | index=" .. tostring(i) .. " | success=" .. tostring(ok) .. " | result=" .. tostring(result))
          if ok then expanded = expanded + 1 end
        end
      end
    elseif seenAny then
      emptyTail = emptyTail + 1
    end
    if seenAny and emptyTail >= 16 then break end
  end
  return expanded
end

local function safeArraySize(array, helperName)
  if array == nil then return -1 end
  local helper = halo and halo[helperName] or nil
  if helper and helper.GetSize then
    local size = -1
    pcall(function() size = helper.GetSize(array) end)
    return size
  end
  return -1
end

local function safeArrayElement(array, helperName, index)
  if array == nil then return nil end
  local helper = halo and halo[helperName] or nil
  if helper and helper.GetElement then
    local value = nil
    pcall(function() value = helper.GetElement(array, index) end)
    return value
  end
  return safeCall(function() return array[index] end)
end

local function buttonText(button)
  local text = safeCall(function()
    return button.Data and button.Data.TextData and button.Data.TextData.Text or nil
  end)
  if text == nil or tostring(text) == "" then
    text = safeCall(function() return button.Data and button.Data.Text or nil end)
  end
  return trim(text) or ""
end

local function buttonIsSelected(button)
  return safeCall(function()
    return button.States and button.States.IsSelected == true
  end) == true
end

local function pressButton(button)
  if button == nil then return false, "button-nil" end
  local states = safeGet(button, "States")
  if states == nil then return false, "states-nil" end
  local fn = safeGet(states, "EventPrimary")
  if type(fn) ~= "function" then return false, "EventPrimary-unavailable" end
  return pcall(function() return states:EventPrimary() end)
end

local function enumerateIslandButtons(buttons)
  local result = {}
  local size = safeArraySize(buttons, "PhoenixArray<halo::CButtonData>")
  if size < 1 then return result, size end
  for i = 0, size - 1 do
    local button = safeArrayElement(buttons, "PhoenixArray<halo::CButtonData>", i)
    if button ~= nil then
      local name = buttonText(button)
      if name ~= "" then
        result[#result + 1] = { index = i, name = name, button = button }
      end
    end
  end
  return result, size
end

local function findIslandButton(buttons, islandName)
  local list, size = enumerateIslandButtons(buttons)
  local target = normalize(islandName)
  for _, rec in ipairs(list) do
    if normalize(rec.name) == target then return rec, list, size end
  end
  return nil, list, size
end

local function clearSelectedIslandButtons(buttons)
  local list = enumerateIslandButtons(buttons)
  local cleared = 0
  for _, rec in ipairs(list) do
    if buttonIsSelected(rec.button) then
      local ok = pressButton(rec.button)
      if ok then cleared = cleared + 1 end
    end
  end
  return cleared
end

local function harvestRouteRows(rows)
  local found = {}
  local seenIDs = {}
  if rows == nil then return found end
  local seenAny = false
  local emptyTail = 0
  for i = 0, 511 do
    local row = safeCall(function() return rows[i] end)
    if row ~= nil and not string.find(tostring(row), "weak null", 1, true) then
      seenAny = true
      emptyTail = 0
      local routeID = safeGet(row, "RouteID")
      local routeName = safeCall(function() return row.NameData and row.NameData.Text or nil end)
      if type(routeID) == "number" and routeID >= 0 and routeName ~= nil and not seenIDs[routeID] then
        seenIDs[routeID] = true
        found[#found + 1] = {
          routeID = routeID,
          routeName = tostring(routeName),
          overviewIndex = i,
          row = row,
          stations = {},
          stationCount = nil,
          membershipConfirmed = true,
          topologyStatus = "pending",
        }
      end
    elseif seenAny then
      emptyTail = emptyTail + 1
    end
    if seenAny and emptyTail >= 16 then break end
  end
  table.sort(found, function(a, b)
    return string.lower(a.routeName) < string.lower(b.routeName)
  end)
  return found
end

local function getShipName(object)
  return readNameableName(object) or trim(safeGet(object, "Name")) or HarborArrivals:_T("unnamed_ship")
end

local function getObjectID(object)
  local id = safeGet(object, "ID")
  return id ~= nil and tostring(id) or nil
end

local function statusForShip(object)
  local tr = safeGet(object, "TradeRouteVehicle")
  if safeGet(tr, "IsPaused") == true then return "PAUSED" end
  if safeGet(tr, "IsAssignedOnTradeRoute") == false then return "NOT ASSIGNED" end
  if safeGet(tr, "IsAssignedOnTradeRoute") == true then return "ACTIVE" end
  return "LIVE"
end

local function distanceFromHarbor(object, context)
  if object == nil or context == nil or context.harborX == nil or context.harborZ == nil then return nil end
  local x, _, z = getVectorCoordinates(safeGet(object, "Position"))
  if x == nil or z == nil then return nil end
  local dx = x - context.harborX
  local dz = z - context.harborZ
  return math.sqrt(dx * dx + dz * dz)
end

local function getPlayTimeMs()
  local value = safeCall(function() return Game and Game.PlayTime or nil end)
  if type(value) == "number" then return value end
  return nil
end

function HarborArrivals._ComputeEtaValidation(predictedAtMs, predictedEtaSeconds, actualAtMs)
  if type(predictedAtMs) ~= "number" or type(predictedEtaSeconds) ~= "number"
    or predictedEtaSeconds < 0 or type(actualAtMs) ~= "number" or actualAtMs < predictedAtMs
  then
    return nil
  end
  local predictedArrivalAtMs = predictedAtMs + predictedEtaSeconds * 1000
  local actualElapsedSeconds = (actualAtMs - predictedAtMs) / 1000
  local errorSeconds = actualElapsedSeconds - predictedEtaSeconds
  local absoluteErrorSeconds = math.abs(errorSeconds)
  local errorPct = nil
  if predictedEtaSeconds > 0 then errorPct = (errorSeconds / predictedEtaSeconds) * 100 end
  return {
    predictedAtMs = predictedAtMs,
    predictedEtaSeconds = predictedEtaSeconds,
    predictedArrivalAtMs = predictedArrivalAtMs,
    actualAtMs = actualAtMs,
    actualElapsedSeconds = actualElapsedSeconds,
    errorSeconds = errorSeconds,
    absoluteErrorSeconds = absoluteErrorSeconds,
    errorPct = errorPct,
  }
end

function HarborArrivals._ComputeQueueAdjustedEtaValidation(validation, queueWaitSeconds)
  if type(validation) ~= "table" or type(validation.predictedEtaSeconds) ~= "number"
    or type(validation.actualElapsedSeconds) ~= "number" then
    return nil
  end
  local waitSeconds = tonumber(queueWaitSeconds) or 0
  if waitSeconds < 0 then waitSeconds = 0 end
  local adjustedElapsedSeconds = math.max(0, validation.actualElapsedSeconds - waitSeconds)
  local adjustedErrorSeconds = adjustedElapsedSeconds - validation.predictedEtaSeconds
  local adjustedAbsoluteErrorSeconds = math.abs(adjustedErrorSeconds)
  local adjustedErrorPct = nil
  if validation.predictedEtaSeconds > 0 then
    adjustedErrorPct = (adjustedErrorSeconds / validation.predictedEtaSeconds) * 100
  end
  return {
    predictedAtMs = validation.predictedAtMs,
    predictedEtaSeconds = validation.predictedEtaSeconds,
    predictedArrivalAtMs = validation.predictedArrivalAtMs,
    actualAtMs = validation.actualAtMs,
    actualElapsedSeconds = adjustedElapsedSeconds,
    errorSeconds = adjustedErrorSeconds,
    absoluteErrorSeconds = adjustedAbsoluteErrorSeconds,
    errorPct = adjustedErrorPct,
    queueWaitSeconds = waitSeconds,
  }
end

function HarborArrivals._UpdateEtaValidationHistory(hist, validation)
  if type(validation) ~= "table" or type(validation.errorSeconds) ~= "number"
    or type(validation.absoluteErrorSeconds) ~= "number" then
    return hist
  end
  hist = type(hist) == "table" and hist or {
    count = 0, totalErrorSeconds = 0, totalAbsoluteErrorSeconds = 0,
    minErrorSeconds = nil, maxErrorSeconds = nil, last = nil,
  }
  hist.count = (tonumber(hist.count) or 0) + 1
  hist.totalErrorSeconds = (tonumber(hist.totalErrorSeconds) or 0) + validation.errorSeconds
  hist.totalAbsoluteErrorSeconds = (tonumber(hist.totalAbsoluteErrorSeconds) or 0) + validation.absoluteErrorSeconds
  hist.meanErrorSeconds = hist.totalErrorSeconds / hist.count
  hist.meanAbsoluteErrorSeconds = hist.totalAbsoluteErrorSeconds / hist.count
  hist.minErrorSeconds = hist.minErrorSeconds == nil and validation.errorSeconds or math.min(hist.minErrorSeconds, validation.errorSeconds)
  hist.maxErrorSeconds = hist.maxErrorSeconds == nil and validation.errorSeconds or math.max(hist.maxErrorSeconds, validation.errorSeconds)
  hist.last = validation
  return hist
end

function HarborArrivals._FormatEtaValidationSummary(label, hist)
  local name = tostring(label or "ETA")
  local count = type(hist) == "table" and tonumber(hist.count) or 0
  if count == nil or count <= 0 then
    return name .. ": no validated samples yet"
  end
  local meanError = tonumber(hist.meanErrorSeconds) or 0
  local meanAbs = tonumber(hist.meanAbsoluteErrorSeconds) or 0
  local lastError = type(hist.last) == "table" and tonumber(hist.last.errorSeconds) or nil
  local text = name .. ": " .. tostring(count) .. " sample" .. (count == 1 and "" or "s") ..
    " | mean error " .. string.format("%+.1fs", meanError) ..
    " | MAE " .. string.format("%.1fs", meanAbs)
  if lastError ~= nil then
    text = text .. " | last " .. string.format("%+.1fs", lastError)
  end
  return text
end

function HarborArrivals._ComputeMotionMetrics(x1, z1, d1, x2, z2, d2, elapsedMs, arrivalRadius)
  if type(x1) ~= "number" or type(z1) ~= "number" or type(d1) ~= "number"
    or type(x2) ~= "number" or type(z2) ~= "number" or type(d2) ~= "number"
    or type(elapsedMs) ~= "number" or elapsedMs <= 0
  then
    return { motion = "TIME/POSITION UNAVAILABLE" }
  end

  arrivalRadius = type(arrivalRadius) == "number" and math.max(0, arrivalRadius) or 0
  local elapsedSeconds = elapsedMs / 1000
  local dx = x2 - x1
  local dz = z2 - z1
  local travelled = math.sqrt(dx * dx + dz * dz)
  local speed = travelled / elapsedSeconds
  local closingSpeed = (d1 - d2) / elapsedSeconds
  local motion = "CROSSING/UNCLEAR"

  if speed < 0.25 then
    motion = "STATIONARY"
  elseif closingSpeed > 0.25 then
    motion = "APPROACHING"
  elseif closingSpeed < -0.25 then
    motion = "DEPARTING"
  end

  local eta = nil
  local remainingDistance = math.max(0, d2 - arrivalRadius)
  local alignment = 0
  if speed > 0.25 then
    alignment = math.abs(closingSpeed) / speed
    if alignment > 1 then alignment = 1 end
  end
  local etaReliable = motion == "APPROACHING"
    and closingSpeed > 0.25
    and alignment >= HarborArrivals.ETA_MIN_ALIGNMENT
  if etaReliable then
    eta = remainingDistance / closingSpeed
    if eta < 0 then eta = nil end
  end

  return {
    motion = motion,
    elapsedSeconds = elapsedSeconds,
    travelled = travelled,
    speed = speed,
    closingSpeed = closingSpeed,
    alignment = alignment,
    etaReliable = etaReliable,
    remainingDistanceToArrivalZone = remainingDistance,
    projectedETASeconds = eta,
  }
end


function HarborArrivals._ComputeThreePointMotionMetrics(
  x1, z1, d1, t1,
  xm, zm, dm, tm,
  x2, z2, d2, t2,
  arrivalRadius
)
  local overallElapsed = (type(t2) == "number" and type(t1) == "number") and (t2 - t1) or nil
  local firstElapsed = (type(tm) == "number" and type(t1) == "number") and (tm - t1) or nil
  local secondElapsed = (type(t2) == "number" and type(tm) == "number") and (t2 - tm) or nil

  local overall = HarborArrivals._ComputeMotionMetrics(x1, z1, d1, x2, z2, d2, overallElapsed, arrivalRadius)
  local first = HarborArrivals._ComputeMotionMetrics(x1, z1, d1, xm, zm, dm, firstElapsed, arrivalRadius)
  local second = HarborArrivals._ComputeMotionMetrics(xm, zm, dm, x2, z2, d2, secondElapsed, arrivalRadius)

  overall.segment1Motion = first.motion
  overall.segment2Motion = second.motion
  overall.segment1ClosingSpeed = first.closingSpeed
  overall.segment2ClosingSpeed = second.closingSpeed
  overall.segment1Alignment = first.alignment
  overall.segment2Alignment = second.alignment
  overall.segment1Speed = first.speed
  overall.segment2Speed = second.speed
  overall.segment1ElapsedMs = firstElapsed
  overall.segment2ElapsedMs = secondElapsed
  overall.weightedClosingSpeed = nil
  overall.stability = "UNAVAILABLE"
  overall.closingSpeedRelativeChange = nil

  local c1 = first.closingSpeed
  local c2 = second.closingSpeed
  if type(c1) == "number" and type(c2) == "number" then
    local denominator = math.max(math.abs(c1), math.abs(c2), 0.5)
    overall.closingSpeedRelativeChange = math.abs(c2 - c1) / denominator
  end

  if overall.motion == "APPROACHING" then
    local bothApproaching = first.motion == "APPROACHING" and second.motion == "APPROACHING"
    local bothAligned = type(first.alignment) == "number" and first.alignment >= HarborArrivals.ETA_MIN_ALIGNMENT
      and type(second.alignment) == "number" and second.alignment >= HarborArrivals.ETA_MIN_ALIGNMENT
    local stableChange = type(overall.closingSpeedRelativeChange) == "number"
      and overall.closingSpeedRelativeChange <= HarborArrivals.ETA_STABILITY_MAX_REL_CHANGE

    if bothApproaching and bothAligned and stableChange then
      overall.stability = "STABLE_APPROACH"
      local recentWeight = HarborArrivals.ETA_RECENT_WEIGHT
      local olderWeight = 1 - recentWeight
      overall.weightedClosingSpeed = olderWeight * c1 + recentWeight * c2
      overall.etaReliable = overall.weightedClosingSpeed > 0.25
      if overall.etaReliable then
        overall.projectedETASeconds = overall.remainingDistanceToArrivalZone / overall.weightedClosingSpeed
      else
        overall.projectedETASeconds = nil
      end
    elseif second.motion == "APPROACHING"
      and type(second.alignment) == "number" and second.alignment >= HarborArrivals.ETA_MIN_ALIGNMENT
    then
      overall.stability = "APPROACH_CHANGING"
      overall.etaReliable = false
      overall.projectedETASeconds = nil
    else
      overall.stability = "TURNING_OR_UNSTABLE"
      overall.etaReliable = false
      overall.projectedETASeconds = nil
    end
  elseif overall.motion == "DEPARTING" then
    if first.motion == "DEPARTING" and second.motion == "DEPARTING"
      and type(overall.closingSpeedRelativeChange) == "number"
      and overall.closingSpeedRelativeChange <= HarborArrivals.ETA_STABILITY_MAX_REL_CHANGE
    then
      overall.stability = "STABLE_DEPARTURE"
    else
      overall.stability = "DEPARTURE_CHANGING"
    end
    overall.etaReliable = false
    overall.projectedETASeconds = nil
  elseif overall.motion == "STATIONARY" then
    overall.stability = "STATIONARY"
    overall.etaReliable = false
    overall.projectedETASeconds = nil
  else
    overall.stability = "DIRECTION_UNCLEAR"
    overall.etaReliable = false
    overall.projectedETASeconds = nil
  end

  return overall
end


function HarborArrivals._AngularDistanceRadians(a, b)
  if type(a) ~= "number" or type(b) ~= "number" then return nil end
  local twoPi = math.pi * 2
  local diff = math.abs((a - b) % twoPi)
  if diff > math.pi then diff = twoPi - diff end
  return diff
end

local function collectCollectionValues(value, maxItems)
  local items = {}
  if value == nil then return items end
  maxItems = maxItems or 16

  if type(value) == "table" then
    local keyed = {}
    local ok = pcall(function()
      for key, item in pairs(value) do
        keyed[#keyed + 1] = { key = key, item = item }
      end
    end)
    if ok then
      table.sort(keyed, function(a, b)
        if type(a.key) == type(b.key) and type(a.key) == "number" then return a.key < b.key end
        return tostring(a.key) < tostring(b.key)
      end)
      for i = 1, math.min(#keyed, maxItems) do items[#items + 1] = keyed[i].item end
      return items
    end
  end

  for index = 0, maxItems - 1 do
    local item = safeGet(value, index)
    if item ~= nil then items[#items + 1] = item end
  end
  return items
end

local function hasNumericValue(values, wanted)
  for _, value in ipairs(values or {}) do
    if tonumber(value) == wanted then return true end
  end
  return false
end

local function decodeModules(value)
  local raw = collectCollectionValues(value, 16)
  local labels = {}
  for _, item in ipairs(raw) do
    local guid = tonumber(item)
    local info = guid and HarborArrivals.MODULE_INFO[guid] or nil
    if info ~= nil then
      labels[#labels + 1] = tostring(guid) .. " " .. info.name
    else
      labels[#labels + 1] = tostring(item)
    end
  end
  return raw, "[" .. table.concat(labels, ", ") .. "]"
end

local function decodeSocketAssets(value)
  local raw = collectCollectionValues(value, 16)
  local labels = {}
  for index, asset in ipairs(raw) do
    local guid = safeGet(asset, "Guid")
    local text = trim(safeGet(asset, "Text"))
    if guid ~= nil or text ~= nil then
      labels[#labels + 1] = tostring(index) .. ":" .. tostring(guid or "?") .. (text and (" " .. text) or "")
    else
      labels[#labels + 1] = tostring(index) .. ":" .. tostring(asset)
    end
  end
  return raw, "[" .. table.concat(labels, ", ") .. "]"
end

local function getWindDirection()
  local scene = safeCall(function() return ui and ui.Scenes and ui.Scenes.MacroMap or nil end)
  local data = safeGet(scene, "MacroMapData")
  local wind = safeGet(data, "WindDirection")
  return wind, data
end

local function compactProbeValue(value)
  if value == nil then return nil end
  local kind = type(value)
  if kind == "string" or kind == "number" or kind == "boolean" then
    return tostring(value)
  end
  local text = tostring(value)
  if text == "nil" or text == "" then return nil end
  return text
end

local function compactPropertyList(object, keys)
  if object == nil then return "unavailable" end
  local parts = {}
  for _, key in ipairs(keys or {}) do
    local value = safeGet(object, key)
    local text = compactProbeValue(value)
    if text ~= nil then
      parts[#parts + 1] = tostring(key) .. "=" .. text
    end
  end
  if #parts == 0 then return "none-exposed" end
  return table.concat(parts, ",")
end

local function compactCollection(value, maxItems)
  if value == nil then return nil end
  maxItems = maxItems or 16
  local parts = {}
  local seen = 0

  if type(value) == "table" then
    local ok = pcall(function()
      for key, item in pairs(value) do
        seen = seen + 1
        if seen <= maxItems then
          parts[#parts + 1] = tostring(key) .. ":" .. tostring(item)
        end
      end
    end)
    if ok then
      if seen > 0 then
        if seen > maxItems then parts[#parts + 1] = "..." end
        return "[" .. table.concat(parts, ",") .. "]"
      end
      return "[]"
    end
  end

  -- Some generated bindings expose vector-like values that are indexable but are not Lua tables.
  -- Probe a small read-only numeric range; no setters or mutation methods are called.
  for index = 0, maxItems - 1 do
    local item = safeGet(value, index)
    if item ~= nil then
      parts[#parts + 1] = tostring(index) .. ":" .. tostring(item)
    end
  end
  if #parts > 0 then
    return "[" .. table.concat(parts, ",") .. "]"
  end

  return compactProbeValue(value)
end

local function getTypeInfoText(value)
  if value == nil then return nil end
  local modern = safeCall(function() return _G and rawget(_G, "getTypeInfo") or nil end)
  if type(modern) == "function" then
    local result = safeCall(function() return modern(value) end)
    if result ~= nil then return tostring(result) end
  end
  local deprecated = safeCall(function() return _G and rawget(_G, "getTypeInfoDeprecated") or nil end)
  if type(deprecated) == "function" then
    local result = safeCall(function() return deprecated(value) end)
    if result ~= nil then return tostring(result) end
  end
  return nil
end

function HarborArrivals:_LogMovementTypeInfo(label, value)
  if value == nil then return end
  self.movementTypeInfoSeen = self.movementTypeInfoSeen or {}
  if self.movementTypeInfoSeen[label] then return end
  self.movementTypeInfoSeen[label] = true

  local text = getTypeInfoText(value)
  if text == nil then
    log("MOVEMENT TYPEINFO | label=" .. tostring(label) .. " | unavailable")
    return
  end
  text = text:gsub("\r", " "):gsub("\n", " ")
  local chunkSize = 1400
  local total = math.max(1, math.ceil(#text / chunkSize))
  for part = 1, total do
    local first = (part - 1) * chunkSize + 1
    local last = math.min(#text, part * chunkSize)
    log("MOVEMENT TYPEINFO | label=" .. tostring(label) ..
        " | part=" .. tostring(part) .. "/" .. tostring(total) ..
        " | value=" .. text:sub(first, last))
  end
end

function HarborArrivals:_ProbeMovementFactors(route, ship)
  if not DEEP_DIAGNOSTICS then return end
  if type(ship) ~= "table" or ship.object == nil then return end
  local object = ship.object
  local tr = safeGet(object, "TradeRouteVehicle")
  local motor = safeGet(object, "Motor")
  local direction = safeGet(object, "Direction")
  local unit = safeGet(object, "Unit")
  local buffable = safeGet(object, "Buffable")
  local moduleOwner = safeGet(object, "ShipModuleOwner")
  local health = safeGet(object, "Health")
  local container = safeGet(object, "ItemContainer")
  local cargo, cargoError = self._ReadCargoSnapshot(object)

  local slotCount = safeGet(container, "SlotCount")
    or safeGet(container, "ContainerSize")
  local stackLimit = cargo and cargo.stackLimit or safeGet(container, "StackLimit")
  local cargoFillPct = nil
  if type(slotCount) == "number" and slotCount > 0 and type(stackLimit) == "number" and stackLimit > 0
    and cargo ~= nil and type(cargo.total) == "number"
  then
    cargoFillPct = (cargo.total / (slotCount * stackLimit)) * 100
  end

  -- Exact read-only property names discovered by the v0.1.11 runtime type-info probe.
  local isMotorized = safeGet(motor, "IsMotorized")
  local directionNumber = type(direction) == "number" and direction or nil
  local unitCampGuid = safeGet(unit, "UnitCampGuid")
  local isMilitaryUnit = safeGet(unit, "IsMilitaryUnit")
  local isBuffed = safeGet(buffable, "IsBuffed")
  local installedModules = safeGet(moduleOwner, "InstalledShipModuleGUIDs")
  local installedModuleValues, installedModulesText = decodeModules(installedModules)
  local currentHitPoints = safeGet(health, "CurrentHitPoints")
  local maximumHitPoints = safeGet(health, "MaximumHitPoints")
  local isRuinStateActive = safeGet(health, "IsRuinStateActive")
  local healthPct = nil
  if type(currentHitPoints) == "number" and type(maximumHitPoints) == "number" and maximumHitPoints > 0 then
    healthPct = (currentHitPoints / maximumHitPoints) * 100
  end
  local sockets = safeGet(container, "Sockets")
  local socketAssets, socketsText = decodeSocketAssets(sockets)
  local canEquipItems = safeGet(container, "CanEquipItems")

  local hullGuid = tonumber(safeGet(object, "GUID"))
  local hullInfo = hullGuid and self.HULL_INFO[hullGuid] or nil
  local configuredBaseSpeed = hullInfo and hullInfo.baseSpeed or nil
  if type(configuredBaseSpeed) == "number" and hasNumericValue(installedModuleValues, 31649) then
    configuredBaseSpeed = configuredBaseSpeed * 0.95
  end
  local measuredSpeed = ship.motion and ship.motion.speed or nil
  local measuredClosingSpeed = ship.motion and ship.motion.closingSpeed or nil
  local measuredAlignment = ship.motion and ship.motion.alignment or nil
  local effectiveSpeedRatio = nil
  if type(measuredSpeed) == "number" and type(configuredBaseSpeed) == "number" and configuredBaseSpeed > 0 then
    effectiveSpeedRatio = measuredSpeed / configuredBaseSpeed
  end
  local windDirection, macroMapData = getWindDirection()
  local windDirectionNumber = type(windDirection) == "number" and windDirection or nil
  -- WorldMapConfig stores WindDirection as degree-style values (e.g. 45), while ship Direction
  -- is a radian angle. v0.1.13 mixed those units in its diagnostic only. Keep both direct
  -- and 180-degree-opposite interpretations until we prove whether WindDirection means
  -- "toward" or "from" wind. ETA itself remains based on live measured ship movement.
  local windDirectionDegreesNormalized = nil
  local windDirectionRadians = nil
  local headingWindDelta = nil
  local headingWindDeltaOpposite = nil
  if windDirectionNumber ~= nil then
    windDirectionDegreesNormalized = ((windDirectionNumber % 360) + 360) % 360
    windDirectionRadians = math.rad(windDirectionNumber)
    headingWindDelta = HarborArrivals._AngularDistanceRadians(directionNumber, windDirectionRadians)
    headingWindDeltaOpposite = HarborArrivals._AngularDistanceRadians(directionNumber, windDirectionRadians + math.pi)
  end

  local firstSocket = socketAssets and socketAssets[1] or nil


  log("MOVEMENT FACTORS | island=" .. tostring(self.context and self.context.islandName) ..
      " | routeID=" .. tostring(route and route.routeID) ..
      " | route=" .. tostring(route and route.routeName) ..
      " | ship=" .. tostring(ship.name) ..
      " | objectID=" .. tostring(ship.idText) ..
      " | hullGUID=" .. tostring(hullGuid) ..
      " | hullName=" .. tostring(hullInfo and hullInfo.name or nil) ..
      " | hullBaseSpeed=" .. tostring(hullInfo and hullInfo.baseSpeed or nil) ..
      " | configuredBaseSpeed=" .. tostring(configuredBaseSpeed) ..
      " | sessionGuid=" .. tostring(safeGet(object, "SessionGuid")) ..
      " | measuredSpeed=" .. tostring(measuredSpeed) ..
      " | measuredClosingSpeed=" .. tostring(measuredClosingSpeed) ..
      " | measuredAlignment=" .. tostring(measuredAlignment) ..
      " | effectiveSpeedRatio=" .. tostring(effectiveSpeedRatio) ..
      " | windDirection=" .. tostring(windDirection) ..
      " | windDirectionDegreesNormalized=" .. tostring(windDirectionDegreesNormalized) ..
      " | windDirectionRadians=" .. tostring(windDirectionRadians) ..
      " | headingWindDelta=" .. tostring(headingWindDelta) ..
      " | headingWindDeltaOpposite=" .. tostring(headingWindDeltaOpposite) ..
      " | cargoTotal=" .. tostring(cargo and cargo.total or nil) ..
      " | cargoStacks=" .. tostring(cargo and cargo.nonzeroStacks or nil) ..
      " | slotCountCandidate=" .. tostring(slotCount) ..
      " | stackLimit=" .. tostring(stackLimit) ..
      " | cargoFillPctCandidate=" .. tostring(cargoFillPct) ..
      " | cargoReadError=" .. tostring(cargoError) ..
      " | isMotorized=" .. tostring(isMotorized) ..
      " | directionValue=" .. tostring(direction) ..
      " | directionNumber=" .. tostring(directionNumber) ..
      " | unitCampGuid=" .. tostring(unitCampGuid) ..
      " | isMilitaryUnit=" .. tostring(isMilitaryUnit) ..
      " | isBuffed=" .. tostring(isBuffed) ..
      " | installedModuleGUIDs=" .. tostring(installedModulesText) ..
      " | currentHitPoints=" .. tostring(currentHitPoints) ..
      " | maximumHitPoints=" .. tostring(maximumHitPoints) ..
      " | healthPct=" .. tostring(healthPct) ..
      " | isRuinStateActive=" .. tostring(isRuinStateActive) ..
      " | canEquipItems=" .. tostring(canEquipItems) ..
      " | sockets=" .. tostring(socketsText))

  log("SPEED CONTEXT | island=" .. tostring(self.context and self.context.islandName) ..
      " | routeID=" .. tostring(route and route.routeID) ..
      " | ship=" .. tostring(ship.name) ..
      " | hullGUID=" .. tostring(hullGuid) ..
      " | hull=" .. tostring(hullInfo and hullInfo.name or "unknown") ..
      " | staticBaseSpeed=" .. tostring(hullInfo and hullInfo.baseSpeed or nil) ..
      " | configuredBaseSpeed=" .. tostring(configuredBaseSpeed) ..
      " | measuredSpeed=" .. tostring(measuredSpeed) ..
      " | effectiveSpeedRatio=" .. tostring(effectiveSpeedRatio) ..
      " | cargoTotal=" .. tostring(cargo and cargo.total or nil) ..
      " | modules=" .. tostring(installedModulesText) ..
      " | healthPct=" .. tostring(healthPct) ..
      " | captainItems=" .. tostring(socketsText))

  log("WIND CONTEXT | island=" .. tostring(self.context and self.context.islandName) ..
      " | ship=" .. tostring(ship.name) ..
      " | windDirectionRaw=" .. tostring(windDirection) ..
      " | windDirectionType=" .. tostring(type(windDirection)) ..
      " | windDirectionDegreesNormalized=" .. tostring(windDirectionDegreesNormalized) ..
      " | windDirectionRadians=" .. tostring(windDirectionRadians) ..
      " | headingDirection=" .. tostring(directionNumber) ..
      " | headingWindDelta=" .. tostring(headingWindDelta) ..
      " | headingWindDeltaOpposite=" .. tostring(headingWindDeltaOpposite) ..
      " | note=diagnostic only; WindDirection converted degrees->radians; both direct/opposite interpretations logged; ETA unchanged")

  for index, asset in ipairs(socketAssets or {}) do
    log("SOCKET ASSET | ship=" .. tostring(ship.name) ..
        " | slot=" .. tostring(index) ..
        " | Guid=" .. tostring(safeGet(asset, "Guid")) ..
        " | Text=" .. tostring(trim(safeGet(asset, "Text"))) ..
        " | Icon=" .. tostring(safeGet(asset, "Icon")))
  end

  log("MOVEMENT SURFACE | ship=" .. tostring(ship.name) ..
      " | TradeRouteVehicle{" .. compactPropertyList(tr, {
        "IsAssignedOnTradeRoute", "IsPaused", "LoadingSpeedFactor", "OnRegularRoute", "RouteName",
        "TradeRouteID", "TargetStationID", "TargetBuildingID", "HarbourEvaluated", "TargetLoadingHarbour",
        "WaitingTime", "RouteStatus"
      }) .. "}")
  log("MOVEMENT SURFACE | ship=" .. tostring(ship.name) ..
      " | Motor{" .. compactPropertyList(motor, {
        "IsMotorized"
      }) .. "}")
  log("MOVEMENT SURFACE | ship=" .. tostring(ship.name) ..
      " | Direction{value=" .. tostring(directionNumber) .. "}")
  log("MOVEMENT SURFACE | ship=" .. tostring(ship.name) ..
      " | Unit{" .. compactPropertyList(unit, {
        "UnitCampGuid", "IsMilitaryUnit"
      }) .. "}")
  log("MOVEMENT SURFACE | ship=" .. tostring(ship.name) ..
      " | Buffable{" .. compactPropertyList(buffable, {
        "IsBuffed"
      }) .. "}")
  log("MOVEMENT SURFACE | ship=" .. tostring(ship.name) ..
      " | ShipModuleOwner{" .. compactPropertyList(moduleOwner, {
        "InstalledShipModuleGUIDs"
      }) .. " | decoded=" .. tostring(installedModulesText) .. "}")
  log("MOVEMENT SURFACE | ship=" .. tostring(ship.name) ..
      " | Health{" .. compactPropertyList(health, {
        "CurrentHitPoints", "MaximumHitPoints", "IsRuinStateActive"
      }) .. " | healthPct=" .. tostring(healthPct) .. "}")
  log("MOVEMENT SURFACE | ship=" .. tostring(ship.name) ..
      " | ItemContainer{" .. compactPropertyList(container, {
        "StackLimit", "InteractingAreaID", "Cargo", "Sockets", "CanEquipItems",
        "DraggedItemAlreadyExclusive", "DraggedItemAlreadyEquipped"
      }) .. " | decodedSockets=" .. tostring(socketsText) .. "}")


  self:_LogMovementTypeInfo("TradeRouteVehicle", tr)
  self:_LogMovementTypeInfo("Motor", motor)
  self:_LogMovementTypeInfo("Direction", direction)
  self:_LogMovementTypeInfo("Unit", unit)
  self:_LogMovementTypeInfo("Buffable", buffable)
  self:_LogMovementTypeInfo("ShipModuleOwner", moduleOwner)
  self:_LogMovementTypeInfo("Health", health)
  self:_LogMovementTypeInfo("ItemContainer", container)
  if not self.gameObjectTypeInfoLogged then
    self.gameObjectTypeInfoLogged = true
    self:_LogMovementTypeInfo("GameObject", object)
  end
  self:_LogMovementTypeInfo("InstalledShipModuleGUIDs", installedModules)
  self:_LogMovementTypeInfo("ItemContainer.Sockets", sockets)
  self:_LogMovementTypeInfo("ItemContainer.SocketAsset", firstSocket)
  self:_LogMovementTypeInfo("MacroMapData", macroMapData)
  self:_LogMovementTypeInfo("MacroMapData.WindDirection", windDirection)
end

function HarborArrivals._ReadBackendStationCount(routeID)
  local manager = safeCall(function()
    return TradeRoute and TradeRoute.get and TradeRoute.get() or nil
  end)
  if manager == nil then return nil, {}, "manager-unavailable" end

  local route = safeCall(function() return manager:GetRoute(routeID) end)
  if route == nil or string.find(tostring(route), "weak null", 1, true) then
    return nil, {}, "route-unavailable"
  end

  local validArgs = {}
  for stationArg = 0, 31 do
    local station = safeCall(function() return route:GetStation(stationArg) end)
    if station ~= nil and not string.find(tostring(station), "weak null", 1, true) then
      local valid = safeCall(function() return station:isValid() end)
      if valid ~= false then validArgs[#validArgs + 1] = stationArg end
    end
  end
  return #validArgs, validArgs, nil
end

local function makeServiceWatchKey(routeID, context, ship)
  local areaPart = tostring(context and context.islandAreaID or context and context.islandName or "?")
  local shipPart = tostring(ship and ship.idText or ship and ship.name or "?")
  return areaPart .. "|" .. tostring(routeID or "?") .. "|" .. shipPart
end

local function makeServiceHistoryKey(routeID, context, ship)
  return makeServiceWatchKey(routeID, context, ship)
end

function HarborArrivals._EtaPredictionDecision(existingPrediction, etaSeconds, stability)
  local eta = tonumber(etaSeconds)
  if eta == nil or eta <= 0 or tostring(stability) ~= "STABLE_APPROACH" then return "SKIP" end
  if type(existingPrediction) == "table" then return "LOCKED" end
  return "RECORD"
end

function HarborArrivals:_RecordEtaPrediction(route, ship)
  if type(route) ~= "table" or type(ship) ~= "table" or self.context == nil then return end
  local eta = ship.arrival and tonumber(ship.arrival.etaSeconds) or nil
  local stability = ship.motion and ship.motion.stability or nil
  local alignment = ship.motion and tonumber(ship.motion.alignment) or nil
  local key = makeServiceWatchKey(route.routeID, self.context, ship)
  local existing = self.etaPredictions and self.etaPredictions[key] or nil

  if existing == nil and eta ~= nil and tostring(stability) == "STABLE_APPROACH"
      and (alignment == nil or alignment < self.INITIAL_ETA_MIN_ALIGNMENT) then
    log("ETA INITIAL DEFERRED | island=" .. tostring(self.context.islandName) ..
        " | routeID=" .. tostring(route.routeID) ..
        " | route=" .. tostring(route.routeName) ..
        " | ship=" .. tostring(ship.name) ..
        " | candidateETASeconds=" .. tostring(eta) ..
        " | distance=" .. tostring(ship.distance) ..
        " | alignment=" .. tostring(alignment) ..
        " | requiredAlignment=" .. tostring(self.INITIAL_ETA_MIN_ALIGNMENT) ..
        " | meaning=initial scan is only marginally aligned; sustained later auto-confirmation will decide when to lock ETA")
    return
  end

  local decision = self._EtaPredictionDecision(existing, eta, stability)
  if decision == "SKIP" then return end
  if decision == "LOCKED" then
    log("ETA PREDICTION LOCKED | island=" .. tostring(existing.islandName) ..
        " | routeID=" .. tostring(existing.routeID) .. " | route=" .. tostring(existing.routeName) ..
        " | ship=" .. tostring(existing.shipName) ..
        " | lockedPredictedAtMs=" .. tostring(existing.predictedAtMs) ..
        " | lockedETASeconds=" .. tostring(existing.predictedEtaSeconds) ..
        " | lockedDistance=" .. tostring(existing.distanceAtPrediction) ..
        " | currentCandidateETASeconds=" .. tostring(eta) ..
        " | currentDistance=" .. tostring(ship.distance) ..
        " | meaning=first reliable ETA for this inbound approach remains authoritative")
    return
  end
  local now = getPlayTimeMs()
  if type(now) ~= "number" then return end
  local rec = {
    key = key, routeID = route.routeID, routeName = route.routeName, shipName = ship.name,
    shipID = ship.idText, islandName = self.context.islandName, islandAreaID = self.context.islandAreaID,
    predictedAtMs = now, predictedEtaSeconds = eta, predictedArrivalAtMs = now + eta * 1000,
    distanceAtPrediction = ship.distance, weightedClosingSpeed = ship.motion.weightedClosingSpeed,
    stability = ship.motion.stability, arrivalZoneValidated = false, serviceValidated = false,
  }
  self.etaPredictions[key] = rec
  log("ETA PREDICTION | island=" .. tostring(rec.islandName) ..
      " | routeID=" .. tostring(rec.routeID) .. " | route=" .. tostring(rec.routeName) ..
      " | ship=" .. tostring(rec.shipName) .. " | predictedAtMs=" .. tostring(rec.predictedAtMs) ..
      " | predictedETASeconds=" .. tostring(rec.predictedEtaSeconds) ..
      " | predictedArrivalAtMs=" .. tostring(rec.predictedArrivalAtMs) ..
      " | distance=" .. tostring(rec.distanceAtPrediction) ..
      " | weightedClosingSpeed=" .. tostring(rec.weightedClosingSpeed) ..
      " | stability=" .. tostring(rec.stability))
end

function HarborArrivals._GetAutoEtaConfirmationPolicy(distance, alignment)
  local d = tonumber(distance)
  local a = tonumber(alignment)
  if d ~= nil and a ~= nil and d <= HarborArrivals.NEAR_ETA_DISTANCE and a >= HarborArrivals.NEAR_ETA_MIN_ALIGNMENT then
    return { mode = "NEAR_FAST", required = HarborArrivals.NEAR_ETA_CONFIRM_REQUIRED, windowMs = HarborArrivals.NEAR_ETA_CONFIRM_WINDOW_MS }
  end
  return { mode = "STANDARD", required = HarborArrivals.AUTO_ETA_CONFIRM_REQUIRED, windowMs = HarborArrivals.AUTO_ETA_CONFIRM_WINDOW_MS }
end

function HarborArrivals._ResetAutoEtaConfirmation(rec)
  if type(rec) ~= "table" then return end
  rec.autoEtaConfirmStartMs = nil
  rec.autoEtaConfirmLastMs = nil
  rec.autoEtaConfirmCount = 0
end

function HarborArrivals._ResetAutoEtaSampler(rec)
  if type(rec) ~= "table" then return end
  rec.autoEtaSample1AtMs = nil
  rec.autoEtaSample1X = nil
  rec.autoEtaSample1Z = nil
  rec.autoEtaSample1Distance = nil
  rec.autoEtaSampleMidAtMs = nil
  rec.autoEtaSampleMidX = nil
  rec.autoEtaSampleMidZ = nil
  rec.autoEtaSampleMidDistance = nil
  HarborArrivals._ResetAutoEtaConfirmation(rec)
end

function HarborArrivals:_RecordAutoEtaPrediction(rec, motion, distance, now, policy)
  if type(rec) ~= "table" or type(motion) ~= "table" or type(now) ~= "number" then return false end
  self.etaPredictions = self.etaPredictions or {}
  local eta = tonumber(motion.projectedETASeconds)
  local decision = self._EtaPredictionDecision(self.etaPredictions[rec.key], eta, motion.stability)
  if decision ~= "RECORD" then return false end

  local prediction = {
    key = rec.key, routeID = rec.routeID, routeName = rec.routeName, shipName = rec.shipName,
    shipID = rec.shipID, islandName = rec.islandName, islandAreaID = rec.islandAreaID,
    predictedAtMs = now, predictedEtaSeconds = eta, predictedArrivalAtMs = now + eta * 1000,
    distanceAtPrediction = distance, weightedClosingSpeed = motion.weightedClosingSpeed,
    alignment = motion.alignment,
    segment1ClosingSpeed = motion.segment1ClosingSpeed,
    segment2ClosingSpeed = motion.segment2ClosingSpeed,
    closingSpeedRelativeChange = motion.closingSpeedRelativeChange,
    stability = motion.stability, arrivalZoneValidated = false, serviceValidated = false,
    source = "auto-watch-confirmed",
    confirmationMode = policy and policy.mode or "STANDARD",
    confirmationSeconds = (policy and policy.windowMs or self.AUTO_ETA_CONFIRM_WINDOW_MS) / 1000,
    confirmationSamples = policy and policy.required or self.AUTO_ETA_CONFIRM_REQUIRED,
  }
  self.etaPredictions[rec.key] = prediction
  log("ETA PREDICTION AUTO-ACQUIRED | island=" .. tostring(prediction.islandName) ..
      " | routeID=" .. tostring(prediction.routeID) .. " | route=" .. tostring(prediction.routeName) ..
      " | ship=" .. tostring(prediction.shipName) .. " | predictedAtMs=" .. tostring(prediction.predictedAtMs) ..
      " | predictedETASeconds=" .. tostring(prediction.predictedEtaSeconds) ..
      " | predictedArrivalAtMs=" .. tostring(prediction.predictedArrivalAtMs) ..
      " | distance=" .. tostring(prediction.distanceAtPrediction) ..
      " | weightedClosingSpeed=" .. tostring(prediction.weightedClosingSpeed) ..
      " | alignment=" .. tostring(prediction.alignment) ..
      " | segment1ClosingSpeed=" .. tostring(prediction.segment1ClosingSpeed) ..
      " | segment2ClosingSpeed=" .. tostring(prediction.segment2ClosingSpeed) ..
      " | closingSpeedRelativeChange=" .. tostring(prediction.closingSpeedRelativeChange) ..
      " | stability=" .. tostring(prediction.stability) ..
      " | confirmationMode=" .. tostring(prediction.confirmationMode) ..
      " | confirmationSeconds=" .. tostring(prediction.confirmationSeconds) ..
      " | confirmationSamples=" .. tostring(prediction.confirmationSamples) ..
      " | meaning=ship remained reliably inbound through sustained confirmation after the original Open scan; ETA is now locked")
  return true
end

function HarborArrivals:_AdvanceAutoEtaSampler(rec, now, x, z, distance)
  if type(rec) ~= "table" then return nil end
  if self.scanActive then
    self._ResetAutoEtaSampler(rec)
    return nil
  end
  if self.etaPredictions and self.etaPredictions[rec.key] ~= nil then
    self._ResetAutoEtaSampler(rec)
    return nil
  end

  local d = tonumber(distance)
  if type(now) ~= "number" or type(x) ~= "number" or type(z) ~= "number" or d == nil or d <= self.ARRIVAL_RADIUS then
    self._ResetAutoEtaSampler(rec)
    return nil
  end

  if type(rec.autoEtaSample1AtMs) ~= "number" then
    rec.autoEtaSample1AtMs = now
    rec.autoEtaSample1X = x
    rec.autoEtaSample1Z = z
    rec.autoEtaSample1Distance = d
    return "SAMPLE1"
  end

  if type(rec.autoEtaSampleMidAtMs) ~= "number" then
    if now - rec.autoEtaSample1AtMs < self.AUTO_ETA_SAMPLE_INTERVAL_MS then return nil end
    rec.autoEtaSampleMidAtMs = now
    rec.autoEtaSampleMidX = x
    rec.autoEtaSampleMidZ = z
    rec.autoEtaSampleMidDistance = d
    return "SAMPLE2"
  end

  if now - rec.autoEtaSampleMidAtMs < self.AUTO_ETA_SAMPLE_INTERVAL_MS then return nil end

  local motion = self._ComputeThreePointMotionMetrics(
    rec.autoEtaSample1X, rec.autoEtaSample1Z, rec.autoEtaSample1Distance, rec.autoEtaSample1AtMs,
    rec.autoEtaSampleMidX, rec.autoEtaSampleMidZ, rec.autoEtaSampleMidDistance, rec.autoEtaSampleMidAtMs,
    x, z, d, now,
    self.ARRIVAL_RADIUS
  )

  -- Keep a rolling two-sample history while the ship is outbound, turning, or
  -- otherwise not yet a stable approach. This lets one Open scan observe
  -- the first later moment at which the ship becomes reliably inbound.
  rec.autoEtaSample1AtMs = rec.autoEtaSampleMidAtMs
  rec.autoEtaSample1X = rec.autoEtaSampleMidX
  rec.autoEtaSample1Z = rec.autoEtaSampleMidZ
  rec.autoEtaSample1Distance = rec.autoEtaSampleMidDistance
  rec.autoEtaSampleMidAtMs = now
  rec.autoEtaSampleMidX = x
  rec.autoEtaSampleMidZ = z
  rec.autoEtaSampleMidDistance = d

  if motion and motion.etaReliable == true and motion.stability == "STABLE_APPROACH" then
    local policy = self._GetAutoEtaConfirmationPolicy(d, motion.alignment)
    if type(rec.autoEtaConfirmStartMs) ~= "number" then
      rec.autoEtaConfirmStartMs = now
      rec.autoEtaConfirmLastMs = now
      rec.autoEtaConfirmCount = 0
      rec.autoEtaConfirmMode = policy.mode
      log("ETA AUTO CONFIRMATION START | island=" .. tostring(rec.islandName) ..
          " | routeID=" .. tostring(rec.routeID) .. " | route=" .. tostring(rec.routeName) ..
          " | ship=" .. tostring(rec.shipName) .. " | distance=" .. tostring(d) ..
          " | candidateETASeconds=" .. tostring(motion.projectedETASeconds) ..
          " | weightedClosingSpeed=" .. tostring(motion.weightedClosingSpeed) ..
          " | alignment=" .. tostring(motion.alignment) ..
          " | segment1ClosingSpeed=" .. tostring(motion.segment1ClosingSpeed) ..
          " | segment2ClosingSpeed=" .. tostring(motion.segment2ClosingSpeed) ..
          " | closingSpeedRelativeChange=" .. tostring(motion.closingSpeedRelativeChange) ..
          " | mode=" .. tostring(policy.mode) ..
          " | requiredConfirmations=" .. tostring(policy.required) ..
          " | confirmationIntervalSeconds=" .. tostring(self.AUTO_ETA_CONFIRM_INTERVAL_MS / 1000) ..
          " | minimumStableSeconds=" .. tostring(policy.windowMs / 1000))
      return "CONFIRMING"
    end

    if now - rec.autoEtaConfirmLastMs >= self.AUTO_ETA_CONFIRM_INTERVAL_MS then
      rec.autoEtaConfirmLastMs = now
      rec.autoEtaConfirmCount = (tonumber(rec.autoEtaConfirmCount) or 0) + 1
      local sustainedMs = now - rec.autoEtaConfirmStartMs
      log("ETA AUTO CONFIRMATION | island=" .. tostring(rec.islandName) ..
          " | routeID=" .. tostring(rec.routeID) .. " | route=" .. tostring(rec.routeName) ..
          " | ship=" .. tostring(rec.shipName) .. " | distance=" .. tostring(d) ..
          " | mode=" .. tostring(policy.mode) ..
          " | confirmation=" .. tostring(rec.autoEtaConfirmCount) .. "/" .. tostring(policy.required) ..
          " | sustainedSeconds=" .. tostring(sustainedMs / 1000) ..
          " | candidateETASeconds=" .. tostring(motion.projectedETASeconds) ..
          " | weightedClosingSpeed=" .. tostring(motion.weightedClosingSpeed) ..
          " | alignment=" .. tostring(motion.alignment) ..
          " | segment1ClosingSpeed=" .. tostring(motion.segment1ClosingSpeed) ..
          " | segment2ClosingSpeed=" .. tostring(motion.segment2ClosingSpeed) ..
          " | closingSpeedRelativeChange=" .. tostring(motion.closingSpeedRelativeChange))
      if rec.autoEtaConfirmCount >= policy.required and sustainedMs >= policy.windowMs then
        if self:_RecordAutoEtaPrediction(rec, motion, d, now, policy) then
          self._ResetAutoEtaSampler(rec)
          return "ACQUIRED"
        end
      end
    end
    return "CONFIRMING"
  end

  if type(rec.autoEtaConfirmStartMs) == "number" then
    local sustainedMs = type(now) == "number" and math.max(0, now - rec.autoEtaConfirmStartMs) or 0
    log("ETA AUTO CONFIRMATION RESET | island=" .. tostring(rec.islandName) ..
        " | routeID=" .. tostring(rec.routeID) .. " | route=" .. tostring(rec.routeName) ..
        " | ship=" .. tostring(rec.shipName) .. " | distance=" .. tostring(d) ..
        " | previousSustainedSeconds=" .. tostring(sustainedMs / 1000) ..
        " | previousConfirmations=" .. tostring(rec.autoEtaConfirmCount or 0) ..
        " | currentStability=" .. tostring(motion and motion.stability) ..
        " | meaning=approach was not continuously stable; confirmation restarts on the next stable approach")
    self._ResetAutoEtaConfirmation(rec)
  end
  return motion and motion.stability or nil
end

function HarborArrivals:_ValidateEtaPrediction(rec, eventType, actualAtMs, distance, detail)
  if rec == nil or type(eventType) ~= "string" or type(actualAtMs) ~= "number" then return nil end
  local prediction = self.etaPredictions and self.etaPredictions[rec.key] or nil
  if prediction == nil then return nil end
  local flag = eventType == "arrival-zone" and "arrivalZoneValidated" or "serviceValidated"
  if prediction[flag] == true then return nil end
  local validation = HarborArrivals._ComputeEtaValidation(prediction.predictedAtMs, prediction.predictedEtaSeconds, actualAtMs)
  if validation == nil then return nil end
  prediction[flag] = true
  prediction[eventType .. "Validation"] = validation
  local rawHistoryKey = eventType == "arrival-zone" and "arrivalZone" or "service"
  local adjustedHistoryKey = eventType == "arrival-zone" and "queueAdjustedArrivalZone" or "queueAdjustedService"
  self.etaValidationHistory[rawHistoryKey] =
    HarborArrivals._UpdateEtaValidationHistory(self.etaValidationHistory[rawHistoryKey], validation)
  local hist = self.etaValidationHistory[rawHistoryKey]
  local queueWaitMs = tonumber(rec.queueWaitAccumMs) or 0
  if rec.queueSuspected and type(rec.queueWaitStartMs) == "number" then
    queueWaitMs = queueWaitMs + math.max(0, actualAtMs - rec.queueWaitStartMs)
  end
  local queueWaitSeconds = queueWaitMs / 1000
  local queueAdjustedValidation = HarborArrivals._ComputeQueueAdjustedEtaValidation(validation, queueWaitSeconds)
  if queueAdjustedValidation ~= nil then
    prediction[eventType .. "QueueAdjustedValidation"] = queueAdjustedValidation
    self.etaValidationHistory[adjustedHistoryKey] =
      HarborArrivals._UpdateEtaValidationHistory(self.etaValidationHistory[adjustedHistoryKey], queueAdjustedValidation)
  end
  local adjustedHist = self.etaValidationHistory[adjustedHistoryKey]
  log("ETA VALIDATION | event=" .. tostring(eventType) ..
      " | island=" .. tostring(rec.islandName) .. " | routeID=" .. tostring(rec.routeID) ..
      " | route=" .. tostring(rec.routeName) .. " | ship=" .. tostring(rec.shipName) ..
      " | predictedETASeconds=" .. tostring(validation.predictedEtaSeconds) ..
      " | actualElapsedSeconds=" .. tostring(validation.actualElapsedSeconds) ..
      " | errorSeconds=" .. tostring(validation.errorSeconds) ..
      " | absoluteErrorSeconds=" .. tostring(validation.absoluteErrorSeconds) ..
      " | errorPct=" .. tostring(validation.errorPct) ..
      " | distance=" .. tostring(distance) .. " | detail=" .. tostring(detail) ..
      " | sampleCount=" .. tostring(hist and hist.count) ..
      " | meanErrorSeconds=" .. tostring(hist and hist.meanErrorSeconds) ..
      " | meanAbsoluteErrorSeconds=" .. tostring(hist and hist.meanAbsoluteErrorSeconds) ..
      " | queueDelayObserved=" .. tostring(queueWaitSeconds > 0) ..
      " | queueWaitSeconds=" .. tostring(queueWaitSeconds) ..
      " | queueAdjustedActualElapsedSeconds=" .. tostring(queueAdjustedValidation and queueAdjustedValidation.actualElapsedSeconds or nil) ..
      " | queueAdjustedErrorSeconds=" .. tostring(queueAdjustedValidation and queueAdjustedValidation.errorSeconds or nil) ..
      " | queueAdjustedAbsoluteErrorSeconds=" .. tostring(queueAdjustedValidation and queueAdjustedValidation.absoluteErrorSeconds or nil) ..
      " | queueAdjustedErrorPct=" .. tostring(queueAdjustedValidation and queueAdjustedValidation.errorPct or nil) ..
      " | queueAdjustedMeanErrorSeconds=" .. tostring(adjustedHist and adjustedHist.meanErrorSeconds or nil) ..
      " | queueAdjustedMAESeconds=" .. tostring(adjustedHist and adjustedHist.meanAbsoluteErrorSeconds or nil))
  return validation
end

local function cargoGuidKey(value)
  if value == nil then return nil end
  if type(value) == "number" then
    if value <= 0 then return nil end
    return tostring(math.floor(value + 0.5))
  end
  local text = trim(value)
  if text == nil or text == "0" then return nil end
  return text
end

function HarborArrivals._ReadCargoSnapshot(object)
  if object == nil then return nil, "ship-object-unavailable" end
  local container = safeGet(object, "ItemContainer")
  if container == nil or string.find(tostring(container), "weak null", 1, true) then
    return nil, "ItemContainer-unavailable"
  end

  local snapshot = {
    total = 0,
    entries = {},
    byGuid = {},
    readableSlots = 0,
    methodErrors = 0,
    interactingAreaID = safeGet(container, "InteractingAreaID"),
    cargoProperty = safeGet(container, "Cargo"),
    stackLimit = safeGet(container, "StackLimit"),
  }

  for slot = 0, HarborArrivals.CARGO_PROBE_MAX_SLOT do
    local okGuid, guidValue = pcall(function() return container:GetStackGUID(slot) end)
    local okSize, sizeValue = pcall(function() return container:GetStackSize(slot) end)
    if okGuid or okSize then snapshot.readableSlots = snapshot.readableSlots + 1 end
    if not okGuid then snapshot.methodErrors = snapshot.methodErrors + 1 end
    if not okSize then snapshot.methodErrors = snapshot.methodErrors + 1 end

    local guid = okGuid and cargoGuidKey(guidValue) or nil
    local size = okSize and tonumber(sizeValue) or nil
    if guid ~= nil and type(size) == "number" and size > 0 then
      snapshot.entries[#snapshot.entries + 1] = { slot = slot, guid = guid, size = size }
      snapshot.byGuid[guid] = (snapshot.byGuid[guid] or 0) + size
      snapshot.total = snapshot.total + size
    end
  end

  table.sort(snapshot.entries, function(a, b) return a.slot < b.slot end)
  local parts = {}
  for _, entry in ipairs(snapshot.entries) do
    parts[#parts + 1] = tostring(entry.slot) .. ":" .. tostring(entry.guid) .. ":" .. tostring(entry.size)
  end
  snapshot.fingerprint = table.concat(parts, ",")
  return snapshot, nil
end

function HarborArrivals._ClassifyCargoChange(before, after)
  if type(before) ~= "table" or type(after) ~= "table" then return nil end
  local keys = {}
  for guid, _ in pairs(before.byGuid or {}) do keys[guid] = true end
  for guid, _ in pairs(after.byGuid or {}) do keys[guid] = true end

  local loaded = 0
  local unloaded = 0
  local loadedByGuid = {}
  local unloadedByGuid = {}
  local changes = {}
  for guid, _ in pairs(keys) do
    local oldAmount = tonumber((before.byGuid or {})[guid]) or 0
    local newAmount = tonumber((after.byGuid or {})[guid]) or 0
    local delta = newAmount - oldAmount
    if delta > 0 then
      loaded = loaded + delta
      loadedByGuid[tostring(guid)] = delta
      changes[#changes + 1] = "+" .. tostring(delta) .. "@" .. tostring(guid)
    elseif delta < 0 then
      unloaded = unloaded - delta
      unloadedByGuid[tostring(guid)] = -delta
      changes[#changes + 1] = tostring(delta) .. "@" .. tostring(guid)
    end
  end
  table.sort(changes)

  local state = nil
  if unloaded > 0 and loaded == 0 then
    state = "UNLOADING"
  elseif loaded > 0 and unloaded == 0 then
    state = "LOADING"
  elseif loaded > 0 and unloaded > 0 then
    state = "UNLOADING + LOADING"
  elseif tostring(before.fingerprint or "") ~= tostring(after.fingerprint or "") then
    state = "CARGO REPOSITIONED"
  end

  if state == nil then return nil end
  return {
    state = state,
    loaded = loaded,
    unloaded = unloaded,
    loadedByGuid = loadedByGuid,
    unloadedByGuid = unloadedByGuid,
    deltaTotal = (tonumber(after.total) or 0) - (tonumber(before.total) or 0),
    changes = table.concat(changes, ";"),
  }
end

function HarborArrivals._AccumulateObservedCargo(rec, change)
  if type(rec) ~= "table" or type(change) ~= "table" then return end
  rec.serviceLoadedByGuid = rec.serviceLoadedByGuid or {}
  rec.serviceUnloadedByGuid = rec.serviceUnloadedByGuid or {}
  for guid, amount in pairs(change.loadedByGuid or {}) do
    rec.serviceLoadedByGuid[tostring(guid)] = (tonumber(rec.serviceLoadedByGuid[tostring(guid)]) or 0) + (tonumber(amount) or 0)
  end
  for guid, amount in pairs(change.unloadedByGuid or {}) do
    rec.serviceUnloadedByGuid[tostring(guid)] = (tonumber(rec.serviceUnloadedByGuid[tostring(guid)]) or 0) + (tonumber(amount) or 0)
  end
end

local function observedCargoText(guid)
  local numericGuid = tonumber(guid)
  if numericGuid ~= nil then
    local asset = safeCall(function() return AssetData(numericGuid) end)
    local text = trim(asset and safeGet(asset, "Text") or nil)
    if text ~= nil and text ~= "" then return text end
  end
  return HarborArrivals:_T("good") .. " " .. tostring(guid)
end

local function formatObservedCargoGroup(label, values)
  local entries = {}
  for guid, amount in pairs(values or {}) do
    local qty = tonumber(amount) or 0
    if qty > 0 then entries[#entries + 1] = { guid = tostring(guid), qty = qty } end
  end
  table.sort(entries, function(a, b)
    local an, bn = tonumber(a.guid), tonumber(b.guid)
    if an ~= nil and bn ~= nil and an ~= bn then return an < bn end
    return a.guid < b.guid
  end)
  if #entries == 0 then return nil end
  local parts = {}
  for _, entry in ipairs(entries) do
    parts[#parts + 1] = tostring(entry.qty) .. " × " .. observedCargoText(entry.guid)
  end
  return "   " .. label .. ": " .. table.concat(parts, ", ")
end

function HarborArrivals._FormatObservedTransferLines(rec)
  local lines = {}
  if type(rec) ~= "table" then return lines end
  local pickingUp = formatObservedCargoGroup(HarborArrivals:_T("picking_up"), rec.serviceLoadedByGuid)
  local unloading = formatObservedCargoGroup(HarborArrivals:_T("unloading"), rec.serviceUnloadedByGuid)
  if pickingUp ~= nil then lines[#lines + 1] = pickingUp end
  if unloading ~= nil then lines[#lines + 1] = unloading end
  return lines
end

-- Format a current read-only cargo snapshot for dashboard display.  This describes only
-- what is physically on board now; it never claims that the goods will be unloaded at
-- the selected harbor.
function HarborArrivals._FormatOnboardCargoSnapshot(snapshot, showAll)
  if type(snapshot) ~= "table" then return nil end
  local entries = {}
  for guid, amount in pairs(snapshot.byGuid or {}) do
    local qty = tonumber(amount) or 0
    if qty > 0 then
      entries[#entries + 1] = { guid = tostring(guid), qty = qty, name = observedCargoText(guid) }
    end
  end
  table.sort(entries, function(a, b)
    local an = string.lower(tostring(a.name or ""))
    local bn = string.lower(tostring(b.name or ""))
    if an ~= bn then return an < bn end
    return tostring(a.guid) < tostring(b.guid)
  end)

  if #entries == 0 then return HarborArrivals:_EmptyCargoLine() end

  local limit = showAll == true and #entries or (tonumber(HarborArrivals.ONBOARD_CARGO_MAX_GOODS) or 4)
  local parts = {}
  for i, entry in ipairs(entries) do
    if i > limit then break end
    parts[#parts + 1] = tostring(entry.qty) .. " × " .. tostring(entry.name)
  end
  if showAll ~= true and #entries > limit then
    parts[#parts + 1] = "+" .. tostring(#entries - limit) .. " " .. HarborArrivals:_T("more")
  end
  return HarborArrivals:_T("on_board") .. ": " .. table.concat(parts, ", ")
end

-- Slow, display-only cache for cargo of ships already enumerated by Harbor Arrivals.
-- The existing CARGO_PROBE_RADIUS transaction watcher remains untouched and authoritative
-- for detecting loading/unloading events near the harbor.
function HarborArrivals:_GetOnboardCargoLine(ship, now, showAll)
  if type(ship) ~= "table" or ship.object == nil then return nil end
  local key = tostring(ship.idText or ship.name or "")
  if key == "" then return nil end

  local currentMs = tonumber(now) or getPlayTimeMs()
  local cached = self.onboardCargoCache and self.onboardCargoCache[key] or nil
  if type(cached) == "table" and type(currentMs) == "number" and type(cached.atMs) == "number"
    and currentMs - cached.atMs < self.ONBOARD_CARGO_REFRESH_INTERVAL_MS
  then
    if showAll == true and cached.snapshot ~= nil then
      return self._FormatOnboardCargoSnapshot(cached.snapshot, true)
    end
    return cached.line
  end

  local reads = tonumber(self.onboardCargoReadsThisReport) or 0
  local budget = tonumber(self.ONBOARD_CARGO_READ_BUDGET_PER_REPORT) or 4
  if reads >= budget then
    if showAll == true and cached and cached.snapshot ~= nil then
      return self._FormatOnboardCargoSnapshot(cached.snapshot, true)
    end
    return cached and cached.line or nil
  end
  self.onboardCargoReadsThisReport = reads + 1

  local snapshot, cargoError = self._ReadCargoSnapshot(ship.object)
  local line = snapshot ~= nil and self._FormatOnboardCargoSnapshot(snapshot) or nil
  self.onboardCargoCache = self.onboardCargoCache or {}
  self.onboardCargoCache[key] = { atMs = currentMs, line = line, snapshot = snapshot, error = cargoError }
  if showAll == true and snapshot ~= nil then
    return self._FormatOnboardCargoSnapshot(snapshot, true)
  end
  return line
end

-- Right-panel-only cargo wrapping. Every detected good remains visible; continuation
-- lines are inserted only at comma boundaries so the native panel does not leave a
-- single trailing good stranded by automatic wrapping. The parchment keeps its
-- existing compact cargo formatter unchanged.
local PANEL_CARGO_WRAP_CHARS = 56
local function wrapPanelCargoLine(cargoLine)
  local text = tostring(cargoLine or "")
  local marker = HarborArrivals:_T("on_board") .. ": "
  if string.sub(text, 1, #marker) ~= marker then
    return { "   " .. text }
  end

  local payload = string.sub(text, #marker + 1)
  local goods = {}
  for part in string.gmatch(payload, "([^,]+)") do
    local item = string.gsub(part, "^%s+", "")
    item = string.gsub(item, "%s+$", "")
    if item ~= "" then goods[#goods + 1] = item end
  end
  if #goods == 0 then return { "   " .. text } end

  local firstPrefix = "   " .. HarborArrivals:_T("on_board") .. ": "
  local continuationPrefix = string.rep(" ", #firstPrefix)
  local lines = {}
  local current = firstPrefix
  local hasItem = false
  for _, item in ipairs(goods) do
    local separator = hasItem and ", " or ""
    local candidate = current .. separator .. item
    if hasItem and #candidate > PANEL_CARGO_WRAP_CHARS then
      lines[#lines + 1] = current
      current = continuationPrefix .. item
      hasItem = true
    else
      current = candidate
      hasItem = true
    end
  end
  lines[#lines + 1] = current
  return lines
end

local function appendPanelCargoLines(panelLines, cargoLine)
  for _, line in ipairs(wrapPanelCargoLine(cargoLine)) do
    panelLines[#panelLines + 1] = line
  end
end

local function otherShipGroup(state)
  local text = tostring(state or "OTHER")
  if string.find(text, "OUTBOUND", 1, true) ~= nil
    or string.find(text, "DEPARTED", 1, true) ~= nil
    or string.find(text, "LEAVING HARBOR", 1, true) ~= nil
  then
    return "OUTBOUND"
  end
  if string.find(text, "DIRECTION UNCLEAR", 1, true) ~= nil or text == "UNCLEAR" then
    return "DIRECTION UNCLEAR"
  end
  if string.find(text, "PAUSED", 1, true) ~= nil then return "PAUSED / WAITING" end
  if string.find(text, "STOPPED", 1, true) ~= nil then return "STOPPED / WAITING" end
  return "OTHER"
end

local function interactionText(value)
  if value == nil then return "nil" end
  return tostring(value)
end

function HarborArrivals:_EnsureServiceWatch(route, ship)
  if type(route) ~= "table" or type(ship) ~= "table" or ship.object == nil or self.context == nil then return nil end
  local key = makeServiceWatchKey(route.routeID, self.context, ship)
  local rec = self.serviceWatch[key]
  local now = getPlayTimeMs()
  local targetContext = {
    harborX = self.context.harborX,
    harborY = self.context.harborY,
    harborZ = self.context.harborZ,
  }
  local d = distanceFromHarbor(ship.object, targetContext)
  if rec == nil then
    local inside = type(d) == "number" and d <= self.ARRIVAL_RADIUS or false
    rec = {
      key = key,
      routeID = route.routeID,
      routeName = route.routeName,
      shipName = ship.name,
      shipID = ship.idText,
      object = ship.object,
      islandName = self.context.islandName,
      islandAreaID = self.context.islandAreaID,
      targetContext = targetContext,
      inside = inside,
      entryAtMs = inside and now or nil,
      entryKnown = false,
      serviceStartReason = inside and "initial-inside" or nil,
      lastDistance = d,
      lastSeenMs = now,
      cargoSnapshot = nil,
      cargoProbeActive = false,
      lastCargoProbeMs = nil,
      lastInteractionAreaID = nil,
      transactionState = nil,
      transactionStateAtMs = nil,
      arrivalZoneObserved = inside,
      serviceEventObserved = inside,
      queueSampleAtMs = nil,
      queueSampleX = nil,
      queueSampleZ = nil,
      queueSuspected = false,
      queueWaitStartMs = nil,
      queueWaitAccumMs = 0,
      queueMovingStreak = 0,
      queueRepositionLogged = false,
      etaQueueDelayLogged = false,
      harborOccupyStartMs = inside and now or nil,
      longBlockerLogged = false,
      lastCargoChangeMs = nil,
      lastCargoChangeState = nil,
      cargoChangeCount = 0,
      lastServiceExitMs = nil,
      autoEtaSample1AtMs = nil,
      autoEtaSample1X = nil,
      autoEtaSample1Z = nil,
      autoEtaSample1Distance = nil,
      autoEtaSampleMidAtMs = nil,
      autoEtaSampleMidX = nil,
      autoEtaSampleMidZ = nil,
      autoEtaSampleMidDistance = nil,
    }
    self.serviceWatch[key] = rec
    log("SERVICE WATCH START | island=" .. tostring(rec.islandName) ..
        " | routeID=" .. tostring(rec.routeID) ..
        " | route=" .. tostring(rec.routeName) ..
        " | ship=" .. tostring(rec.shipName) ..
        " | distance=" .. tostring(d) ..
        " | inside=" .. tostring(inside) ..
        " | entryKnown=false")
  else
    rec.routeName = route.routeName
    rec.shipName = ship.name
    rec.object = ship.object
    rec.targetContext = targetContext
    rec.lastDistance = d
    rec.lastSeenMs = now
  end
  return rec
end

function HarborArrivals:_RecordServiceHistory(rec, durationSeconds)
  if rec == nil or type(durationSeconds) ~= "number" or durationSeconds < 0 then return end
  local key = rec.key
  local hist = self.serviceHistory[key]
  if hist == nil then
    hist = { count = 0, totalSeconds = 0, lastSeconds = nil, minSeconds = nil, maxSeconds = nil }
    self.serviceHistory[key] = hist
  end
  hist.count = hist.count + 1
  hist.totalSeconds = hist.totalSeconds + durationSeconds
  hist.lastSeconds = durationSeconds
  hist.minSeconds = hist.minSeconds == nil and durationSeconds or math.min(hist.minSeconds, durationSeconds)
  hist.maxSeconds = hist.maxSeconds == nil and durationSeconds or math.max(hist.maxSeconds, durationSeconds)
  hist.averageSeconds = hist.totalSeconds / hist.count
end

function HarborArrivals:_LogEtaApproachMilestones(rec, now, previousDistance, distance)
  if type(rec) ~= "table" or type(now) ~= "number" then return end
  local prediction = self.etaPredictions and self.etaPredictions[rec.key] or nil
  if type(prediction) ~= "table" then return end

  local previous = tonumber(previousDistance)
  local current = tonumber(distance)
  local startDistance = tonumber(prediction.distanceAtPrediction)
  local lockedSpeed = tonumber(prediction.weightedClosingSpeed)
  local predictedAtMs = tonumber(prediction.predictedAtMs)
  if previous == nil or current == nil or startDistance == nil or lockedSpeed == nil or lockedSpeed <= 0 or predictedAtMs == nil then
    return
  end

  prediction.approachMilestonesLogged = prediction.approachMilestonesLogged or {}

  for _, threshold in ipairs(self.ETA_APPROACH_MILESTONES or {}) do
    local alreadyLogged = prediction.approachMilestonesLogged[threshold] == true
    -- Only record a threshold when this locked ETA actually started outside it
    -- and the watcher observes the ship crossing inward through it.
    if not alreadyLogged and startDistance > threshold and previous > threshold and current <= threshold then
      prediction.approachMilestonesLogged[threshold] = true

      local actualElapsedSeconds = math.max(0, now - predictedAtMs) / 1000
      local expectedElapsedSeconds = math.max(0, startDistance - threshold) / lockedSpeed
      local milestoneErrorSeconds = actualElapsedSeconds - expectedElapsedSeconds
      local lockedRemainingAtThresholdSeconds = math.max(0, threshold - self.ARRIVAL_RADIUS) / lockedSpeed
      local realizedAverageClosingSpeed = nil
      if actualElapsedSeconds > 0 then
        realizedAverageClosingSpeed = math.max(0, startDistance - threshold) / actualElapsedSeconds
      end
      local realizedVsLockedSpeedRatio = nil
      if type(realizedAverageClosingSpeed) == "number" and lockedSpeed > 0 then
        realizedVsLockedSpeedRatio = realizedAverageClosingSpeed / lockedSpeed
      end

      log("ETA APPROACH MILESTONE" ..
          " | island=" .. tostring(rec.islandName) ..
          " | routeID=" .. tostring(rec.routeID) ..
          " | route=" .. tostring(rec.routeName) ..
          " | ship=" .. tostring(rec.shipName) ..
          " | threshold=" .. tostring(threshold) ..
          " | previousDistance=" .. tostring(previous) ..
          " | currentDistance=" .. tostring(current) ..
          " | predictionStartDistance=" .. tostring(startDistance) ..
          " | lockedClosingSpeed=" .. tostring(lockedSpeed) ..
          " | predictedETASeconds=" .. tostring(prediction.predictedEtaSeconds) ..
          " | expectedElapsedToThresholdSeconds=" .. tostring(expectedElapsedSeconds) ..
          " | actualElapsedToThresholdSeconds=" .. tostring(actualElapsedSeconds) ..
          " | thresholdErrorSeconds=" .. tostring(milestoneErrorSeconds) ..
          " | realizedAverageClosingSpeed=" .. tostring(realizedAverageClosingSpeed) ..
          " | realizedVsLockedSpeedRatio=" .. tostring(realizedVsLockedSpeedRatio) ..
          " | lockedRemainingFromThresholdTo30Seconds=" .. tostring(lockedRemainingAtThresholdSeconds) ..
          " | meaning=diagnostic-only comparison of locked speed versus realized approach speed")
    end
  end
end

function HarborArrivals:UpdateServiceWatches()
  local now = getPlayTimeMs()
  if type(now) ~= "number" then return end
  if type(self.lastServiceTickPlayTime) == "number" and now - self.lastServiceTickPlayTime < 250 then return end
  self.lastServiceTickPlayTime = now

  local harborBlockerCount = 0
  for _, other in pairs(self.serviceWatch or {}) do
    local od = distanceFromHarbor(other.object, other.targetContext)
    if type(od) == "number" and od <= self.ARRIVAL_RADIUS then
      harborBlockerCount = harborBlockerCount + 1
    end
  end

  for _, rec in pairs(self.serviceWatch or {}) do
    local d = distanceFromHarbor(rec.object, rec.targetContext)
    if type(d) == "number" then
      local previousDistance = rec.lastDistance
      rec.lastDistance = d
      rec.lastSeenMs = now
      self:_LogEtaApproachMilestones(rec, now, previousDistance, d)

      local autoX, _, autoZ = getVectorCoordinates(safeGet(rec.object, "Position"))
      self:_AdvanceAutoEtaSampler(rec, now, autoX, autoZ, d)

      -- Harbor-approach queue diagnostic. Travel ETA and queue delay are deliberately
      -- separate. Small movements while still in the approach queue are repositioning,
      -- not a true queue exit.
      if d > self.ARRIVAL_RADIUS and d <= self.CARGO_PROBE_RADIUS then
        local qx, _, qz = getVectorCoordinates(safeGet(rec.object, "Position"))
        if type(rec.queueSampleAtMs) ~= "number" or type(qx) ~= "number" or type(qz) ~= "number" then
          rec.queueSampleAtMs = now
          rec.queueSampleX = qx
          rec.queueSampleZ = qz
        elseif now - rec.queueSampleAtMs >= self.QUEUE_SAMPLE_INTERVAL_MS then
          local displacement = nil
          if type(rec.queueSampleX) == "number" and type(rec.queueSampleZ) == "number" then
            local dx = qx - rec.queueSampleX
            local dz = qz - rec.queueSampleZ
            displacement = math.sqrt(dx * dx + dz * dz)
          end
          local action, nextStreak = self._ClassifyQueueSample(rec.queueSuspected, harborBlockerCount, displacement, d, rec.queueMovingStreak)
          rec.queueMovingStreak = nextStreak or 0

          if action == "SUSPECT" then
            rec.queueSuspected = true
            rec.queueWaitStartMs = rec.queueSampleAtMs
            rec.queueMovingStreak = 0
            rec.queueRepositionLogged = false
            log("HARBOR QUEUE SUSPECT | island=" .. tostring(rec.islandName) ..
                " | routeID=" .. tostring(rec.routeID) .. " | route=" .. tostring(rec.routeName) ..
                " | ship=" .. tostring(rec.shipName) .. " | distance=" .. tostring(d) ..
                " | displacement5s=" .. tostring(displacement) ..
                " | harborBlockerCount=" .. tostring(harborBlockerCount) ..
                " | meaning=stationary in approach zone while harbor occupied")
          elseif action == "REPOSITIONING" then
            if not rec.queueRepositionLogged then
              rec.queueRepositionLogged = true
              local currentWaitMs = tonumber(rec.queueWaitAccumMs) or 0
              if type(rec.queueWaitStartMs) == "number" then currentWaitMs = currentWaitMs + math.max(0, now - rec.queueWaitStartMs) end
              log("HARBOR QUEUE REPOSITIONING | island=" .. tostring(rec.islandName) ..
                  " | routeID=" .. tostring(rec.routeID) .. " | route=" .. tostring(rec.routeName) ..
                  " | ship=" .. tostring(rec.shipName) .. " | distance=" .. tostring(d) ..
                  " | displacement5s=" .. tostring(displacement) ..
                  " | sustainedMovingSamples=" .. tostring(rec.queueMovingStreak) ..
                  " | queueWaitSecondsSoFar=" .. tostring(currentWaitMs / 1000) ..
                  " | meaning=movement inside queue; wait timer continues")
            end
          elseif action == "WAITING" then
            rec.queueRepositionLogged = false
          elseif action == "RESUME" then
            local waitedMs = 0
            if type(rec.queueWaitStartMs) == "number" then waitedMs = math.max(0, now - rec.queueWaitStartMs) end
            rec.queueWaitAccumMs = (tonumber(rec.queueWaitAccumMs) or 0) + waitedMs
            log("HARBOR QUEUE RESUME | island=" .. tostring(rec.islandName) ..
                " | routeID=" .. tostring(rec.routeID) .. " | route=" .. tostring(rec.routeName) ..
                " | ship=" .. tostring(rec.shipName) .. " | distance=" .. tostring(d) ..
                " | displacement5s=" .. tostring(displacement) ..
                " | sustainedMovingSamples=" .. tostring(rec.queueMovingStreak) ..
                " | queueWaitSeconds=" .. tostring((tonumber(rec.queueWaitAccumMs) or 0) / 1000) ..
                " | reason=sustained-movement")
            rec.queueSuspected = false
            rec.queueWaitStartMs = nil
            rec.queueMovingStreak = 0
            rec.queueRepositionLogged = false
            rec.etaQueueDelayLogged = false
          end

          if rec.queueSuspected then
            local prediction = self.etaPredictions and self.etaPredictions[rec.key] or nil
            if prediction ~= nil and not rec.etaQueueDelayLogged then
              rec.etaQueueDelayLogged = true
              log("ETA QUEUE DELAY | island=" .. tostring(rec.islandName) ..
                  " | routeID=" .. tostring(rec.routeID) .. " | route=" .. tostring(rec.routeName) ..
                  " | ship=" .. tostring(rec.shipName) ..
                  " | predictedETASeconds=" .. tostring(prediction.predictedEtaSeconds) ..
                  " | distance=" .. tostring(d) ..
                  " | harborBlockerCount=" .. tostring(harborBlockerCount))
            end
          end
          rec.queueSampleAtMs = now
          rec.queueSampleX = qx
          rec.queueSampleZ = qz
        end
      else
        if rec.queueSuspected then
          local action = self._ClassifyQueueSample(true, harborBlockerCount, nil, d, rec.queueMovingStreak)
          local waitedMs = 0
          if type(rec.queueWaitStartMs) == "number" then waitedMs = math.max(0, now - rec.queueWaitStartMs) end
          rec.queueWaitAccumMs = (tonumber(rec.queueWaitAccumMs) or 0) + waitedMs
          if action == "RESUME_SERVICE" or action == "RESUME_LEFT_APPROACH" then
            log("HARBOR QUEUE RESUME | island=" .. tostring(rec.islandName) ..
                " | routeID=" .. tostring(rec.routeID) .. " | route=" .. tostring(rec.routeName) ..
                " | ship=" .. tostring(rec.shipName) .. " | distance=" .. tostring(d) ..
                " | queueWaitSeconds=" .. tostring((tonumber(rec.queueWaitAccumMs) or 0) / 1000) ..
                " | reason=" .. tostring(action == "RESUME_SERVICE" and "entered-service" or "left-approach-zone"))
          end
        end
        rec.queueSuspected = false
        rec.queueWaitStartMs = nil
        rec.queueMovingStreak = 0
        rec.queueRepositionLogged = false
        rec.queueSampleAtMs = nil
        rec.queueSampleX = nil
        rec.queueSampleZ = nil
        rec.etaQueueDelayLogged = false
      end

      -- Read-only cargo transaction probe. This does not call AddProducts,
      -- MoveProducts, RemoveStacks, ClearSlot, or any other mutating method.
      if d <= self.CARGO_PROBE_RADIUS then
        local due = type(rec.lastCargoProbeMs) ~= "number" or now - rec.lastCargoProbeMs >= self.CARGO_PROBE_INTERVAL_MS
        if due then
          rec.lastCargoProbeMs = now
          local snapshot, cargoError = self._ReadCargoSnapshot(rec.object)
          if snapshot ~= nil then
            if not rec.cargoProbeActive then
              rec.cargoProbeActive = true
              rec.cargoSnapshot = snapshot
              rec.lastInteractionAreaID = snapshot.interactingAreaID
              log("CARGO PROBE START | island=" .. tostring(rec.islandName) ..
                  " | routeID=" .. tostring(rec.routeID) ..
                  " | route=" .. tostring(rec.routeName) ..
                  " | ship=" .. tostring(rec.shipName) ..
                  " | distance=" .. tostring(d) ..
                  " | total=" .. tostring(snapshot.total) ..
                  " | nonzeroStacks=" .. tostring(#snapshot.entries) ..
                  " | readableSlots=" .. tostring(snapshot.readableSlots) ..
                  " | methodErrors=" .. tostring(snapshot.methodErrors) ..
                  " | interactingAreaID=" .. interactionText(snapshot.interactingAreaID) ..
                  " | cargoProperty=" .. tostring(snapshot.cargoProperty) ..
                  " | stackLimit=" .. tostring(snapshot.stackLimit) ..
                  " | fingerprint=" .. tostring(snapshot.fingerprint))
            else
              if tostring(rec.lastInteractionAreaID) ~= tostring(snapshot.interactingAreaID) then
                log("HARBOR INTERACTION | island=" .. tostring(rec.islandName) ..
                    " | routeID=" .. tostring(rec.routeID) ..
                    " | route=" .. tostring(rec.routeName) ..
                    " | ship=" .. tostring(rec.shipName) ..
                    " | distance=" .. tostring(d) ..
                    " | from=" .. interactionText(rec.lastInteractionAreaID) ..
                    " | to=" .. interactionText(snapshot.interactingAreaID))
                rec.lastInteractionAreaID = snapshot.interactingAreaID
              end

              local change = self._ClassifyCargoChange(rec.cargoSnapshot, snapshot)
              if change ~= nil then
                if not rec.serviceEventObserved and d <= self.CARGO_SERVICE_START_RADIUS then
                  rec.serviceEventObserved = true
                  self:_ValidateEtaPrediction(rec, "service", now, d, change.state)
                end
                if not rec.inside and d <= self.CARGO_SERVICE_START_RADIUS then
                  rec.inside = true
                  rec.entryAtMs = now
                  rec.entryKnown = true
                  rec.harborOccupyStartMs = rec.harborOccupyStartMs or now
                  rec.longBlockerLogged = false
                  rec.serviceStartReason = "cargo-transfer"
                  rec.serviceLoadedByGuid = {}
                  rec.serviceUnloadedByGuid = {}
                  log("SERVICE ENTER | island=" .. tostring(rec.islandName) ..
                      " | routeID=" .. tostring(rec.routeID) ..
                      " | route=" .. tostring(rec.routeName) ..
                      " | ship=" .. tostring(rec.shipName) ..
                      " | distance=" .. tostring(d) ..
                      " | reason=cargo-transfer" ..
                      " | transactionState=" .. tostring(change.state) ..
                      " | cargoServiceStartRadius=" .. tostring(self.CARGO_SERVICE_START_RADIUS))
                end
                rec.transactionState = change.state
                rec.transactionStateAtMs = now
                rec.lastCargoChangeMs = now
                rec.lastCargoChangeState = change.state
                rec.cargoChangeCount = (tonumber(rec.cargoChangeCount) or 0) + 1
                self._AccumulateObservedCargo(rec, change)
                log("CARGO CHANGE | island=" .. tostring(rec.islandName) ..
                    " | routeID=" .. tostring(rec.routeID) ..
                    " | route=" .. tostring(rec.routeName) ..
                    " | ship=" .. tostring(rec.shipName) ..
                    " | distance=" .. tostring(d) ..
                    " | state=" .. tostring(change.state) ..
                    " | loaded=" .. tostring(change.loaded) ..
                    " | unloaded=" .. tostring(change.unloaded) ..
                    " | deltaTotal=" .. tostring(change.deltaTotal) ..
                    " | changes=" .. tostring(change.changes) ..
                    " | interactingAreaID=" .. interactionText(snapshot.interactingAreaID) ..
                    " | before=" .. tostring(rec.cargoSnapshot and rec.cargoSnapshot.fingerprint) ..
                    " | after=" .. tostring(snapshot.fingerprint))
              elseif type(rec.transactionStateAtMs) == "number" and now - rec.transactionStateAtMs > self.TRANSACTION_STATE_TTL_MS then
                rec.transactionState = nil
                rec.transactionStateAtMs = nil
              end
              rec.cargoSnapshot = snapshot
            end
          elseif not rec.cargoProbeErrorLogged then
            rec.cargoProbeErrorLogged = true
            log("CARGO PROBE ERROR | island=" .. tostring(rec.islandName) ..
                " | routeID=" .. tostring(rec.routeID) ..
                " | route=" .. tostring(rec.routeName) ..
                " | ship=" .. tostring(rec.shipName) ..
                " | distance=" .. tostring(d) ..
                " | error=" .. tostring(cargoError))
          end
        end
      elseif rec.cargoProbeActive then
        log("CARGO PROBE END | island=" .. tostring(rec.islandName) ..
            " | routeID=" .. tostring(rec.routeID) ..
            " | route=" .. tostring(rec.routeName) ..
            " | ship=" .. tostring(rec.shipName) ..
            " | distance=" .. tostring(d))
        rec.cargoProbeActive = false
        rec.cargoSnapshot = nil
        rec.lastCargoProbeMs = nil
        rec.lastInteractionAreaID = nil
        rec.transactionState = nil
        rec.transactionStateAtMs = nil
      end

      if d <= self.ARRIVAL_RADIUS then
        rec.harborOccupyStartMs = rec.harborOccupyStartMs or now
        local waitingShips = 0
        for _, other in pairs(self.serviceWatch or {}) do
          if other ~= rec and other.queueSuspected then waitingShips = waitingShips + 1 end
        end
        local occupiedMs = math.max(0, now - rec.harborOccupyStartMs)
        local cargoAgeMs = type(rec.lastCargoChangeMs) == "number" and math.max(0, now - rec.lastCargoChangeMs) or nil
        local blockerState = self._LongBlockerState(occupiedMs, waitingShips, rec.lastCargoChangeState, cargoAgeMs)
        if blockerState ~= nil and not rec.longBlockerLogged then
          rec.longBlockerLogged = true
          log("LONG HARBOR BLOCKER | island=" .. tostring(rec.islandName) ..
              " | routeID=" .. tostring(rec.routeID) .. " | route=" .. tostring(rec.routeName) ..
              " | ship=" .. tostring(rec.shipName) .. " | distance=" .. tostring(d) ..
              " | occupiedSeconds=" .. tostring(occupiedMs / 1000) ..
              " | waitingShips=" .. tostring(waitingShips) ..
              " | lastCargoState=" .. tostring(rec.lastCargoChangeState) ..
              " | lastCargoAgeSeconds=" .. tostring(cargoAgeMs and cargoAgeMs / 1000 or nil) ..
              " | state=" .. tostring(blockerState))
        end
      end

      if d <= self.ARRIVAL_RADIUS and not rec.arrivalZoneObserved then
        rec.arrivalZoneObserved = true
        self:_ValidateEtaPrediction(rec, "arrival-zone", now, d, "geometric-arrival-zone")
      end

      if not rec.inside and d <= self.ARRIVAL_RADIUS then
        rec.inside = true
        rec.entryAtMs = now
        rec.entryKnown = true
        rec.harborOccupyStartMs = rec.harborOccupyStartMs or now
        rec.longBlockerLogged = false
        rec.serviceStartReason = "arrival-zone"
        rec.serviceLoadedByGuid = {}
        rec.serviceUnloadedByGuid = {}
        rec.transactionState = nil
        rec.transactionStateAtMs = nil
        if not rec.serviceEventObserved then
          rec.serviceEventObserved = true
          self:_ValidateEtaPrediction(rec, "service", now, d, "arrival-zone-fallback")
        end
        log("SERVICE ENTER | island=" .. tostring(rec.islandName) ..
            " | routeID=" .. tostring(rec.routeID) ..
            " | route=" .. tostring(rec.routeName) ..
            " | ship=" .. tostring(rec.shipName) ..
            " | distance=" .. tostring(d) ..
            " | reason=arrival-zone" ..
            " | arrivalRadius=" .. tostring(self.ARRIVAL_RADIUS))
      elseif rec.inside and d >= self.SERVICE_EXIT_RADIUS then
        local durationSeconds = nil
        if type(rec.entryAtMs) == "number" then durationSeconds = math.max(0, (now - rec.entryAtMs) / 1000) end
        if rec.entryKnown and type(durationSeconds) == "number" then
          self:_RecordServiceHistory(rec, durationSeconds)
        end
        log("SERVICE EXIT | island=" .. tostring(rec.islandName) ..
            " | routeID=" .. tostring(rec.routeID) ..
            " | route=" .. tostring(rec.routeName) ..
            " | ship=" .. tostring(rec.shipName) ..
            " | distance=" .. tostring(d) ..
            " | serviceSeconds=" .. tostring(durationSeconds) ..
            " | completeObservation=" .. tostring(rec.entryKnown) ..
            " | startReason=" .. tostring(rec.serviceStartReason) ..
            " | meaning=service begins at first observed cargo transfer or close arrival-zone entry, whichever is proven first")
        rec.inside = false
        rec.entryAtMs = nil
        rec.entryKnown = false
        rec.serviceStartReason = nil
        rec.harborOccupyStartMs = nil
        rec.longBlockerLogged = false
        rec.transactionState = nil
        rec.transactionStateAtMs = nil
        rec.arrivalZoneObserved = false
        rec.serviceEventObserved = false
        rec.lastServiceExitMs = now
        self._ResetAutoEtaSampler(rec)
        local prediction = self.etaPredictions and self.etaPredictions[rec.key] or nil
        if prediction ~= nil and (prediction.arrivalZoneValidated or prediction.serviceValidated) then
          self.etaPredictions[rec.key] = nil
        end
      end
    end
  end
end

function HarborArrivals:_GetServiceHistory(route, ship)
  if type(route) ~= "table" or type(ship) ~= "table" or self.context == nil then return nil end
  local key = makeServiceHistoryKey(route.routeID, self.context, ship)
  return self.serviceHistory[key]
end

function HarborArrivals:_GetServiceWatch(route, ship)
  if type(route) ~= "table" or type(ship) ~= "table" or self.context == nil then return nil end
  local key = makeServiceWatchKey(route.routeID, self.context, ship)
  return self.serviceWatch[key]
end

local function activeShipsForRoute(routeName, context)
  local ships = {}
  local objects = safeCall(function()
    return Scripts:GetObjectGroupByProperty(Properties.ShipModuleOwner)
  end) or {}
  pcall(function()
    for _, object in pairs(objects) do
      local tr = safeGet(object, "TradeRouteVehicle")
      if tr ~= nil
        and safeGet(tr, "IsAssignedOnTradeRoute") == true
        and trim(safeGet(tr, "RouteName")) == tostring(routeName)
      then
        local x, y, z = getVectorCoordinates(safeGet(object, "Position"))
        ships[#ships + 1] = {
          object = object,
          name = getShipName(object),
          idText = getObjectID(object),
          status = statusForShip(object),
          x = x,
          y = y,
          z = z,
          distance = distanceFromHarbor(object, context),
          sample1X = x,
          sample1Z = z,
          sample1Distance = distanceFromHarbor(object, context),
          motion = nil,
        }
      end
    end
  end)
  table.sort(ships, function(a, b)
    return string.lower(a.name) < string.lower(b.name)
  end)
  return ships
end

local function probeNonRouteShips(context, harvestedRoutes)
  local harvestedIDs = {}
  local routeOwner = nil

  for _, route in ipairs(harvestedRoutes or {}) do
    for _, ship in ipairs(route.ships or {}) do
      harvestedIDs[tostring(ship.idText)] = true
      if routeOwner == nil and ship.object ~= nil then
        routeOwner = safeGet(ship.object, "Owner")
      end
    end
  end

  local objects = safeCall(function()
    return Scripts:GetObjectGroupByProperty(Properties.ShipModuleOwner)
  end) or {}

  local totalShipObjects = 0
  local unassignedCount = 0
  local ownerMatchedCount = 0
  local candidates = {}

  pcall(function()
    for _, object in pairs(objects) do
      totalShipObjects = totalShipObjects + 1
      local idText = getObjectID(object)
      local tr = safeGet(object, "TradeRouteVehicle")
      local assigned = tr ~= nil and safeGet(tr, "IsAssignedOnTradeRoute") == true

      if not harvestedIDs[tostring(idText)] and not assigned then
        unassignedCount = unassignedCount + 1
        local owner = safeGet(object, "Owner")
        local ownerMatches = routeOwner ~= nil and owner ~= nil and tostring(owner) == tostring(routeOwner)
        if ownerMatches then
          ownerMatchedCount = ownerMatchedCount + 1
          local x, y, z = getVectorCoordinates(safeGet(object, "Position"))
          local d = distanceFromHarbor(object, context)
          candidates[#candidates + 1] = {
            object = object,
            name = getShipName(object),
            idText = idText,
            status = statusForShip(object),
            owner = owner,
            sample1X = x,
            sample1Y = y,
            sample1Z = z,
            sample1Distance = d,
            distance = d,
            motion = nil,
          }
        end
      end
    end
  end)

  HarborArrivals.manualShipCandidates = candidates
  HarborArrivals.manualShipResults = {}
  HarborArrivals.manualShipsAtHarbor = {}
  HarborArrivals.manualShipOwner = routeOwner

  log("NON-ROUTE SHIP PROBE SUMMARY" ..
      " | island=" .. tostring(context and context.islandName) ..
      " | totalShipObjects=" .. tostring(totalShipObjects) ..
      " | unassignedShipObjects=" .. tostring(unassignedCount) ..
      " | ownerMatchedUnassigned=" .. tostring(ownerMatchedCount) ..
      " | candidateCount=" .. tostring(#candidates) ..
      " | routeOwner=" .. tostring(routeOwner) ..
      " | meaning=owner-matched manual ships will be sampled over the same three-point motion window")
end

local function openTradeRouteMenu()
  local fn = safeCall(function() return Scripts and Scripts.ToggleTraderouteMenu or nil end)
  if type(fn) ~= "function" then return false, "ToggleTraderouteMenu-unavailable" end
  return pcall(function() return Scripts:ToggleTraderouteMenu() end)
end

local function closeTradeRouteSceneForNormalize()
  local scene = safeCall(function() return ui and ui.Scenes and ui.Scenes.TradeRoute or nil end)
  local fn = safeGet(scene, "CloseTradeRouteScene")
  if type(fn) ~= "function" then return false, "CloseTradeRouteScene-unavailable" end
  return pcall(function() return scene:CloseTradeRouteScene() end)
end

local function formatDuration(seconds)
  if type(seconds) ~= "number" or seconds < 0 then return nil end
  local rounded = math.floor(seconds + 0.5)
  local minutes = math.floor(rounded / 60)
  local secs = rounded % 60
  if minutes > 0 then return string.format("%d:%02d", minutes, secs) end
  return tostring(secs) .. "s"
end

function HarborArrivals._FormatStationPath(stations)
  if type(stations) ~= "table" or #stations == 0 then return "unavailable" end
  local names = {}
  for _, station in ipairs(stations) do
    local name = trim(station and station.islandName) or "?"
    names[#names + 1] = name
  end
  return table.concat(names, " -> ")
end

function HarborArrivals._FormatRouteTopology(route)
  if route == nil then return "topology unavailable" end
  if type(route.stations) == "table" and #route.stations > 0 then
    return HarborArrivals._FormatStationPath(route.stations)
  end
  if type(route.stationCount) == "number" then
    if route.stationCount == 2 then return "2-stop route" end
    return tostring(route.stationCount) .. " stops"
  end
  return "topology unavailable"
end

function HarborArrivals._ClassifyArrival(ship, route, islandName)
  local result = {
    state = "UNCLEAR",
    bucket = "other",
    etaSeconds = nil,
    confidence = "LOW",
  }
  if type(ship) ~= "table" then return result end

  local distance = ship.distance
  local motion = ship.motion and ship.motion.motion or nil
  local stations = route and route.stations or nil
  local stationCount = route and route.stationCount or nil
  if type(stationCount) ~= "number" then
    stationCount = type(stations) == "table" and #stations or 0
  end
  local target = normalize(islandName)
  local selectedOnRoute = route and route.membershipConfirmed == true or false
  if not selectedOnRoute and target ~= nil and type(stations) == "table" then
    for _, station in ipairs(stations) do
      if normalize(station and station.islandName) == target then
        selectedOnRoute = true
        break
      end
    end
  end

  local twoStopConfidence = selectedOnRoute and stationCount == 2
  if type(distance) == "number" and motion == "DEPARTING" and distance <= HarborArrivals.SERVICE_EXIT_RADIUS then
    result.state = "LEAVING HARBOR"
    result.bucket = "other"
    result.etaSeconds = nil
    result.confidence = twoStopConfidence and "HIGH" or "MEDIUM"
    return result
  end
  if type(distance) == "number" and distance <= HarborArrivals.ARRIVAL_RADIUS then
    result.state = "AT HARBOR / SERVICING"
    result.bucket = "arrival"
    result.etaSeconds = 0
    result.confidence = twoStopConfidence and "HIGH" or "MEDIUM"
    return result
  end

  if ship.status == "PAUSED" then
    result.state = "PAUSED / WAITING"
    result.confidence = selectedOnRoute and "MEDIUM" or "LOW"
    return result
  end

  if motion == "APPROACHING" then
    local etaReliable = ship.motion and ship.motion.etaReliable == true
    result.bucket = "arrival"
    result.etaSeconds = ship.motion and ship.motion.projectedETASeconds or nil
    if etaReliable then
      result.state = twoStopConfidence and "INBOUND" or "POSSIBLY INBOUND"
      result.confidence = twoStopConfidence and "HIGH" or "MEDIUM"
    else
      result.state = "POSSIBLY INBOUND / TURNING"
      result.confidence = "MEDIUM"
    end
  elseif motion == "DEPARTING" then
    result.state = "OUTBOUND"
    result.confidence = twoStopConfidence and "HIGH" or "MEDIUM"
  elseif motion == "STATIONARY" then
    if type(distance) == "number" and distance <= HarborArrivals.SERVICE_EXIT_RADIUS then
      result.state = "WAITING NEAR HARBOR"
      result.bucket = "arrival"
      result.confidence = selectedOnRoute and "MEDIUM" or "LOW"
    else
      result.state = "STOPPED / WAITING"
      result.confidence = selectedOnRoute and "MEDIUM" or "LOW"
    end
  elseif motion == "CROSSING/UNCLEAR" then
    result.state = "DIRECTION UNCLEAR"
    result.confidence = selectedOnRoute and "MEDIUM" or "LOW"
  end
  return result
end

function HarborArrivals:_BuildLiveManualBuckets()
  local approaching = {}
  local atHarbor = {}
  local seen = {}

  local function consider(ship)
    if type(ship) ~= "table" then return end
    local key = tostring(ship.idText or ship.name or "")
    if key == "" or seen[key] then return end
    seen[key] = true

    local liveDistance = nil
    if ship.object ~= nil then
      liveDistance = distanceFromHarbor(ship.object, self.context)
    end
    if type(liveDistance) ~= "number" then
      liveDistance = ship.distance
    end

    if type(liveDistance) == "number" and liveDistance <= self.CARGO_SERVICE_START_RADIUS then
      atHarbor[#atHarbor + 1] = {
        object = ship.object,
        name = ship.name,
        idText = ship.idText,
        status = ship.status,
        distance = liveDistance,
        atHarbor = true,
        manual = true,
      }
    elseif type(ship.predictedArrivalAtMs) == "number" then
      local copy = {}
      for k, v in pairs(ship) do copy[k] = v end
      copy.distance = liveDistance
      approaching[#approaching + 1] = copy
    end
  end

  for _, ship in ipairs(self.manualShipResults or {}) do consider(ship) end
  for _, ship in ipairs(self.manualShipsAtHarbor or {}) do consider(ship) end

  table.sort(approaching, function(a, b)
    local ea = tonumber(a.predictedArrivalAtMs)
    local eb = tonumber(b.predictedArrivalAtMs)
    if ea ~= nil and eb ~= nil then return ea < eb end
    if ea ~= nil then return true end
    if eb ~= nil then return false end
    return string.lower(tostring(a.name)) < string.lower(tostring(b.name))
  end)

  table.sort(atHarbor, function(a, b)
    return string.lower(tostring(a.name)) < string.lower(tostring(b.name))
  end)

  return approaching, atHarbor
end

-- Parchment-only jump navigation. The right-side arrival panel deliberately does not
-- participate in this mapping. Entries are rebuilt from the visible parchment on every
-- live refresh so slot numbers always match the current parchment ordering.
function HarborArrivals:_ResetParchmentJumpEntries()
  self.parchmentJumpEntries = {}
end

function HarborArrivals:_RegisterParchmentJump(ship, routeName)
  if type(ship) ~= "table" then return nil end
  local idText = trim(ship.idText)
  if idText == nil and ship.object ~= nil then idText = getObjectID(ship.object) end
  if idText == nil then return nil end

  self.parchmentJumpEntries = self.parchmentJumpEntries or {}
  for slot, entry in ipairs(self.parchmentJumpEntries) do
    if entry ~= nil and tostring(entry.idText) == tostring(idText) then
      return slot
    end
  end
  if #self.parchmentJumpEntries >= 9 then return nil end

  local slot = #self.parchmentJumpEntries + 1
  self.parchmentJumpEntries[slot] = {
    idText = tostring(idText),
    name = tostring(ship.name or self:_T("ship")),
    routeName = tostring(routeName or ""),
  }
  return slot
end

function HarborArrivals:_ParchmentShipPrefix(ship, routeName)
  local slot = self:_RegisterParchmentJump(ship, routeName)
  if slot ~= nil then return "[" .. tostring(slot) .. "] ▶ " end
  return "• "
end

function HarborArrivals:IsParchmentActive()
  if self.liveDashboardActive ~= true or self.lastAppliedReportText == nil then return false end
  local content = safeCall(function()
    return ui.Scenes.TextPopup.SceneData.Content
  end)
  if content == nil then return false end
  local currentText = safeGet(content, "Text")
  return currentText ~= nil and tostring(currentText) == tostring(self.lastAppliedReportText)
end

function HarborArrivals:_ResolveLiveShipForParchmentJump(target)
  if type(target) ~= "table" then return nil, "missing-target" end
  local targetIDText = trim(target.idText)
  if targetIDText == nil then return nil, "missing-id" end

  local objects = safeCall(function()
    return Scripts:GetObjectGroupByProperty(Properties.ShipModuleOwner)
  end) or {}
  for _, object in pairs(objects) do
    if getObjectID(object) == targetIDText then
      return object, "idText"
    end
  end
  return nil, "ship-not-live-in-current-session"
end

function HarborArrivals:_DeactivateParchmentAfterControl()
  self.liveDashboardActive = false
  self.lastAppliedReportText = nil
  self.lastLiveRefreshMs = nil
  self.parchmentJumpEntries = {}
end

function HarborArrivals:HandleParchmentControl(slot)
  local n = tonumber(slot)
  if n == nil or n < 0 or n > 9 or n ~= math.floor(n) then
    log("PARCHMENT CONTROL IGNORED | slot=" .. tostring(slot) .. " | reason=invalid-slot")
    return false
  end
  if not self:IsParchmentActive() then
    -- Shared controls broadcast to all installed consumers. Stay silent when this
    -- mod does not own the active parchment so normal use of other utilities does
    -- not create Harbor Arrivals log noise.
    return false
  end

  if n == 0 then
    local closeOk, closeErr = pcall(function() Scripts:PopUI() end)
    if closeOk then self:_DeactivateParchmentAfterControl() end
    log("PARCHMENT BACK | closeSuccess=" .. tostring(closeOk) .. " | closeError=" .. tostring(closeErr or ""))
    return closeOk
  end

  local target = self.parchmentJumpEntries and self.parchmentJumpEntries[n] or nil
  if target == nil then
    log("PARCHMENT CONTROL IGNORED | slot=" .. tostring(n) .. " | reason=no-numbered-ship")
    return false
  end

  local liveObject, resolveMethod = self:_ResolveLiveShipForParchmentJump(target)
  if liveObject == nil then
    log("PARCHMENT SHIP JUMP | slot=" .. tostring(n) .. " | ship=" .. tostring(target.name) ..
        " | targetID=" .. tostring(target.idText) .. " | result=not-found | reason=" .. tostring(resolveMethod))
    return false
  end
  local liveID = safeGet(liveObject, "ID")
  if liveID == nil then
    log("PARCHMENT SHIP JUMP | slot=" .. tostring(n) .. " | ship=" .. tostring(target.name) ..
        " | targetID=" .. tostring(target.idText) .. " | result=no-live-id")
    return false
  end

  log("PARCHMENT SHIP SELECT | slot=" .. tostring(n) .. " | ship=" .. tostring(target.name) ..
      " | liveObjectId=" .. tostring(liveID) .. " | resolveMethod=" .. tostring(resolveMethod))

  local closeOk, closeErr = pcall(function() Scripts:PopUI() end)
  if not closeOk then
    log("PARCHMENT SHIP JUMP | slot=" .. tostring(n) .. " | ship=" .. tostring(target.name) ..
        " | result=close-failed | closeError=" .. tostring(closeErr or ""))
    return false
  end
  self:_DeactivateParchmentAfterControl()

  local selectOk, selectErr = pcall(function()
    Selection:SelectByID(liveID)
  end)
  local jumpOk, jumpErr = false, nil
  if selectOk then
    jumpOk, jumpErr = pcall(function()
      Scripts:JumpToObject(liveID)
    end)
  end

  log("PARCHMENT SHIP JUMP | slot=" .. tostring(n) .. " | ship=" .. tostring(target.name) ..
      " | liveObjectId=" .. tostring(liveID) .. " | resolveMethod=" .. tostring(resolveMethod) ..
      " | closeSuccess=" .. tostring(closeOk) .. " | selectSuccess=" .. tostring(selectOk) ..
      " | jumpSuccess=" .. tostring(jumpOk) .. " | closeError=" .. tostring(closeErr or "") ..
      " | selectError=" .. tostring(selectErr or "") .. " | jumpError=" .. tostring(jumpErr or ""))
  return selectOk and jumpOk
end

function HarborArrivals:BuildReport()
  local c = self.context
  local lines = {}
  self:_ResetParchmentJumpEntries()
  self.onboardCargoReadsThisReport = 0
  self.panelVisible = false
  self.panelHeaderText = ""
  self.panelDescriptionText = ""
  lines[#lines + 1] = self:_T("harbor_arrivals")
  lines[#lines + 1] = ""

  if c == nil then
    lines[#lines + 1] = self:_T("no_object_selected")
    lines[#lines + 1] = self:_T("select_harbor_retry")
    return table.concat(lines, "\n")
  end

  if self.failureReason == "ship-selected-select-harbor" then
    lines[#lines + 1] = self:_T("ship_selected_title")
    lines[#lines + 1] = self:_T("ship_selected_explain")
    lines[#lines + 1] = self:_T("select_harbor_itself_retry")
    return table.concat(lines, "\n")
  end

  if self.failureReason == "harbor-position-unavailable" then
    lines[#lines + 1] = self:_T("no_harbor_selected")
    lines[#lines + 1] = self:_T("no_harbor_position")
    lines[#lines + 1] = self:_T("select_harbor_itself_retry")
    return table.concat(lines, "\n")
  end


  if self.failureReason ~= nil then
    lines[#lines + 1] = ""
    lines[#lines + 1] = self:_T("route_scan_failed")
    lines[#lines + 1] = self:_T("stage_reason") .. ": " .. tostring(self.failureReason)
    lines[#lines + 1] = ""
    lines[#lines + 1] = self:_T("send_log") .. ": " .. TAG
    return table.concat(lines, "\n")
  end

  local nextArrivals = {}
  local harborNow = {}
  local waitingForHarbor = {}
  local etaStabilizing = {}
  local otherShips = {}
  local liveManualApproaching, liveManualAtHarbor = self:_BuildLiveManualBuckets()
  local shipCount = 0
  local reportNow = getPlayTimeMs()

  for _, route in ipairs(self.routes or {}) do
    for _, ship in ipairs(route.ships or {}) do
      shipCount = shipCount + 1
      ship.arrival = ship.arrival or HarborArrivals._ClassifyArrival(ship, route, c.islandName)
      local watch = self:_GetServiceWatch(route, ship)
      local key = makeServiceWatchKey(route.routeID, c, ship)
      local prediction = self.etaPredictions and self.etaPredictions[key] or nil
      local view = self._LiveReportState(ship.arrival, watch, prediction, reportNow)
      local rec = { route = route, ship = ship, arrival = ship.arrival, watch = watch, prediction = prediction, view = view }

      if view.section == "harbor" then
        harborNow[#harborNow + 1] = rec
      elseif view.section == "waiting" then
        waitingForHarbor[#waitingForHarbor + 1] = rec
      elseif view.section == "travel" and type(view.etaSeconds) == "number" then
        nextArrivals[#nextArrivals + 1] = rec
      elseif view.section == "stabilizing" then
        etaStabilizing[#etaStabilizing + 1] = rec
      else
        otherShips[#otherShips + 1] = rec
      end
    end
  end

  table.sort(nextArrivals, function(a, b)
    local ae = tonumber(a.view and a.view.etaSeconds) or math.huge
    local be = tonumber(b.view and b.view.etaSeconds) or math.huge
    if ae ~= be then return ae < be end
    return string.lower(a.ship.name or "") < string.lower(b.ship.name or "")
  end)
  table.sort(waitingForHarbor, function(a, b)
    local aw = a.watch and tonumber(a.watch.queueWaitAccumMs) or 0
    local bw = b.watch and tonumber(b.watch.queueWaitAccumMs) or 0
    if aw ~= bw then return aw > bw end
    return string.lower(a.ship.name or "") < string.lower(b.ship.name or "")
  end)
  table.sort(harborNow, function(a, b)
    return string.lower(a.ship.name or "") < string.lower(b.ship.name or "")
  end)
  table.sort(etaStabilizing, function(a, b)
    return string.lower(a.ship.name or "") < string.lower(b.ship.name or "")
  end)
  table.sort(otherShips, function(a, b)
    if tostring(a.view and a.view.state) ~= tostring(b.view and b.view.state) then
      return tostring(a.view and a.view.state) < tostring(b.view and b.view.state)
    end
    return string.lower(a.ship.name or "") < string.lower(b.ship.name or "")
  end)

  local harborCount = #harborNow + #liveManualAtHarbor

  -- v0.1.58 layout rule: RIGHT PANEL = arrivals board / future timing.
  -- The parchment carries current harbor operations and untimed serving ships.
  -- This keeps ETA information on the right without duplicating it on the parchment.
  local panelArrivals = {}
  for _, rec in ipairs(nextArrivals) do
    panelArrivals[#panelArrivals + 1] = {
      etaSeconds = tonumber(rec.view and rec.view.etaSeconds),
      name = tostring(rec.ship.name or self:_T("ship")),
      routeName = tostring(rec.route.routeName or ""),
      manual = false,
      cargoLine = self:_GetOnboardCargoLine(rec.ship, reportNow, true),
    }
  end
  for _, ship in ipairs(liveManualApproaching) do
    local remainingSeconds = nil
    if type(ship.predictedArrivalAtMs) == "number" and type(reportNow) == "number" then
      remainingSeconds = math.max(0, (ship.predictedArrivalAtMs - reportNow) / 1000)
    elseif type(ship.etaSeconds) == "number" then
      remainingSeconds = ship.etaSeconds
    end
    panelArrivals[#panelArrivals + 1] = {
      etaSeconds = remainingSeconds,
      name = tostring(ship.name or self:_T("ship")),
      routeName = self:_T("manually_directed"),
      manual = true,
      cargoLine = self:_GetOnboardCargoLine(ship, reportNow, true),
    }
  end
  table.sort(panelArrivals, function(a, b)
    local ae = tonumber(a.etaSeconds) or math.huge
    local be = tonumber(b.etaSeconds) or math.huge
    if ae ~= be then return ae < be end
    return string.lower(tostring(a.name)) < string.lower(tostring(b.name))
  end)

  local panelLines = {}
  panelLines[#panelLines + 1] = self:_T("next_arrivals") .. " — " .. tostring(#panelArrivals)
  if #panelArrivals == 0 then
    panelLines[#panelLines + 1] = self:_T("no_confirmed_arrivals")
  else
    for _, item in ipairs(panelArrivals) do
      local etaText = type(item.etaSeconds) == "number" and formatDuration(item.etaSeconds) or nil
      local prefix = etaText ~= nil and ("~" .. tostring(etaText)) or "ETA ?"
      local suffix = item.manual and (" — " .. self:_T("manual")) or (item.routeName ~= "" and (" — " .. tostring(item.routeName)) or "")
      panelLines[#panelLines + 1] = "<b>" .. prefix .. "</b>" .. "  •  " .. "<b>" .. tostring(item.name) .. "</b>" .. suffix
      local cargoLine = item.cargoLine
      if cargoLine ~= nil and cargoLine ~= self:_EmptyCargoLine() then
        appendPanelCargoLines(panelLines, cargoLine)
      end
    end
  end

  if #etaStabilizing > 0 then
    panelLines[#panelLines + 1] = ""
    panelLines[#panelLines + 1] = self:_T("eta_stabilizing_heading") .. " — " .. tostring(#etaStabilizing)
    for _, rec in ipairs(etaStabilizing) do
      panelLines[#panelLines + 1] = "• " .. "<b>" .. tostring(rec.ship.name) .. "</b>" .. " — " .. tostring(rec.route.routeName)
      local cargoLine = self:_GetOnboardCargoLine(rec.ship, reportNow, true)
      if cargoLine ~= nil and cargoLine ~= self:_EmptyCargoLine() then
        appendPanelCargoLines(panelLines, cargoLine)
      end
    end
  end

  panelLines[#panelLines + 1] = ""
  panelLines[#panelLines + 1] = self:_T("updates_live")

  self.panelVisible = true
  self.panelHeaderText = self:_FormatHarborHeader(c.islandName)
  self.panelDescriptionText = table.concat(panelLines, "\n")

  -- v0.1.61 parchment = structured current harbor operations + categorized untimed ships.
  -- Arrival countdowns remain exclusively on the right panel.
  lines[1] = self:_T("harbor_arrivals") .. " — " .. tostring(c.islandName or self:_T("selected_harbor"))

  lines[#lines + 1] = self:_T("harbor_status")
  lines[#lines + 1] = self:_T("at_harbor") .. ": " .. tostring(harborCount) .. "  •  " .. self:_T("waiting") .. ": " .. tostring(#waitingForHarbor)
  lines[#lines + 1] = self:_T("incoming") .. ": " .. tostring(#panelArrivals) .. "  •  " .. self:_T("eta_stabilizing") .. ": " .. tostring(#etaStabilizing)

  if harborCount > 0 then
    lines[#lines + 1] = ""
    lines[#lines + 1] = self:_T("harbor_now") .. " — " .. tostring(harborCount)
    for _, rec in ipairs(harborNow) do
      local displayState = rec.view and rec.view.state or rec.arrival.state
      local watch = rec.watch
      local blockerState = nil

      if watch ~= nil and watch.transactionState ~= nil and string.find(tostring(displayState), "SERVICING /", 1, true) == nil then
        displayState = "SERVICING / " .. tostring(watch.transactionState)
      end
      if watch ~= nil then
        local occupiedMs = type(reportNow) == "number" and type(watch.harborOccupyStartMs) == "number" and math.max(0, reportNow - watch.harborOccupyStartMs) or 0
        local cargoAgeMs = type(reportNow) == "number" and type(watch.lastCargoChangeMs) == "number" and math.max(0, reportNow - watch.lastCargoChangeMs) or nil
        blockerState = self._LongBlockerState(occupiedMs, #waitingForHarbor, watch.lastCargoChangeState, cargoAgeMs)
        if blockerState ~= nil then displayState = blockerState end
      end

      local conciseState = tostring(displayState or "AT HARBOR / SERVICING")
      if blockerState ~= nil then
        conciseState = self:_DisplayState(blockerState)
      elseif watch ~= nil and (watch.transactionState ~= nil or watch.lastCargoChangeState ~= nil) then
        local tx = tostring(watch.transactionState or watch.lastCargoChangeState)
        if tx == "UNLOADING" then conciseState = self:_T("unloading")
        elseif tx == "LOADING" then conciseState = self:_T("loading")
        elseif tx == "UNLOADING + LOADING" then conciseState = self:_T("unloading_loading")
        else conciseState = self:_DisplayState(tx) end
      elseif conciseState == "AT HARBOR / SERVICING" then
        conciseState = self:_T("servicing")
      else
        conciseState = self:_DisplayState(conciseState)
      end

      lines[#lines + 1] = self:_ParchmentShipPrefix(rec.ship, rec.route.routeName) .. tostring(rec.ship.name) .. " — " .. tostring(conciseState)
      lines[#lines + 1] = "   " .. self:_T("route") .. ": " .. tostring(rec.route.routeName)
      local currentCargo = watch ~= nil and self._FormatOnboardCargoSnapshot(watch.cargoSnapshot) or nil
      if currentCargo == nil then currentCargo = self:_GetOnboardCargoLine(rec.ship, reportNow) end
      if currentCargo ~= nil then lines[#lines + 1] = "   " .. currentCargo end
      for _, transferLine in ipairs(self._FormatObservedTransferLines(watch)) do
        lines[#lines + 1] = transferLine
      end
    end

    for _, ship in ipairs(liveManualAtHarbor) do
      lines[#lines + 1] = self:_ParchmentShipPrefix(ship, self:_T("manually_directed")) .. tostring(ship.name) .. " — " .. self:_T("manually_directed_lower")
      local cargoLine = self:_GetOnboardCargoLine(ship, reportNow)
      if cargoLine ~= nil then lines[#lines + 1] = "   " .. cargoLine end
    end
  end

  if #waitingForHarbor > 0 then
    lines[#lines + 1] = ""
    lines[#lines + 1] = self:_T("waiting_for_harbor") .. " — " .. tostring(#waitingForHarbor)
    for _, rec in ipairs(waitingForHarbor) do
      local watch = rec.watch
      local waitMs = watch and tonumber(watch.queueWaitAccumMs) or 0
      if watch ~= nil and type(reportNow) == "number" and type(watch.queueWaitStartMs) == "number" then
        waitMs = waitMs + math.max(0, reportNow - watch.queueWaitStartMs)
      end
      local waitText = waitMs > 0 and (formatDuration(waitMs / 1000) or "?") or self:_T("waiting_word")
      lines[#lines + 1] = self:_ParchmentShipPrefix(rec.ship, rec.route.routeName) .. tostring(rec.ship.name) .. " — " .. tostring(waitText)
      lines[#lines + 1] = "   " .. self:_T("route") .. ": " .. tostring(rec.route.routeName)
      local cargoLine = self:_GetOnboardCargoLine(rec.ship, reportNow)
      if cargoLine ~= nil then lines[#lines + 1] = "   " .. cargoLine end
    end
  end

  if #otherShips > 0 then
    lines[#lines + 1] = ""
    lines[#lines + 1] = self:_T("ships_without_arrival_time") .. " — " .. tostring(#otherShips)

    local groups = {
      ["OUTBOUND"] = {},
      ["PAUSED / WAITING"] = {},
      ["STOPPED / WAITING"] = {},
      ["DIRECTION UNCLEAR"] = {},
      ["OTHER"] = {},
    }
    for _, rec in ipairs(otherShips) do
      local groupName = otherShipGroup(rec.view and rec.view.state or rec.arrival.state)
      groups[groupName][#groups[groupName] + 1] = rec
    end

    local groupOrder = { "OUTBOUND", "PAUSED / WAITING", "STOPPED / WAITING", "DIRECTION UNCLEAR", "OTHER" }
    for _, groupName in ipairs(groupOrder) do
      local group = groups[groupName]
      if #group > 0 then
        lines[#lines + 1] = ""
        lines[#lines + 1] = self:_GroupLabel(groupName) .. " — " .. tostring(#group)
        for _, rec in ipairs(group) do
          local stateText = tostring(rec.view and rec.view.state or rec.arrival.state or "")
          local suffix = groupName == "OTHER" and stateText ~= "" and (" — " .. self:_DisplayState(stateText)) or ""
          lines[#lines + 1] = self:_ParchmentShipPrefix(rec.ship, rec.route.routeName) .. tostring(rec.ship.name) .. suffix
          lines[#lines + 1] = "   " .. self:_T("route") .. ": " .. tostring(rec.route.routeName)
          local cargoLine = self:_GetOnboardCargoLine(rec.ship, reportNow)
          if cargoLine ~= nil then lines[#lines + 1] = "   " .. cargoLine end
        end
      end
    end
  end

  if #(self.parchmentJumpEntries or {}) > 0 then
    lines[#lines + 1] = ""
    lines[#lines + 1] = self:_T("numbered_jump_help")
  end

  local arrivalValidationHist = self.etaValidationHistory and self.etaValidationHistory.arrivalZone or nil
  local serviceValidationHist = self.etaValidationHistory and self.etaValidationHistory.service or nil
  local queueAdjustedArrivalHist = self.etaValidationHistory and self.etaValidationHistory.queueAdjustedArrivalZone or nil
  local queueAdjustedServiceHist = self.etaValidationHistory and self.etaValidationHistory.queueAdjustedService or nil
  local arrivalValidationCount = type(arrivalValidationHist) == "table" and tonumber(arrivalValidationHist.count) or 0
  local serviceValidationCount = type(serviceValidationHist) == "table" and tonumber(serviceValidationHist.count) or 0
  local validationSignature = table.concat({
    tostring(arrivalValidationCount or 0),
    tostring(arrivalValidationHist and arrivalValidationHist.meanErrorSeconds or nil),
    tostring(arrivalValidationHist and arrivalValidationHist.meanAbsoluteErrorSeconds or nil),
    tostring(queueAdjustedArrivalHist and queueAdjustedArrivalHist.meanErrorSeconds or nil),
    tostring(queueAdjustedArrivalHist and queueAdjustedArrivalHist.meanAbsoluteErrorSeconds or nil),
    tostring(serviceValidationCount or 0),
    tostring(serviceValidationHist and serviceValidationHist.meanErrorSeconds or nil),
    tostring(serviceValidationHist and serviceValidationHist.meanAbsoluteErrorSeconds or nil),
    tostring(queueAdjustedServiceHist and queueAdjustedServiceHist.meanErrorSeconds or nil),
    tostring(queueAdjustedServiceHist and queueAdjustedServiceHist.meanAbsoluteErrorSeconds or nil),
  }, "|")
  if self.lastValidationSummarySignature ~= validationSignature then
    self.lastValidationSummarySignature = validationSignature
    log("ETA VALIDATION SESSION SUMMARY | arrivalCount=" .. tostring(arrivalValidationCount or 0) ..
        " | arrivalMeanErrorSeconds=" .. tostring(arrivalValidationHist and arrivalValidationHist.meanErrorSeconds or nil) ..
        " | arrivalMAESeconds=" .. tostring(arrivalValidationHist and arrivalValidationHist.meanAbsoluteErrorSeconds or nil) ..
        " | queueAdjustedArrivalMeanErrorSeconds=" .. tostring(queueAdjustedArrivalHist and queueAdjustedArrivalHist.meanErrorSeconds or nil) ..
        " | queueAdjustedArrivalMAESeconds=" .. tostring(queueAdjustedArrivalHist and queueAdjustedArrivalHist.meanAbsoluteErrorSeconds or nil) ..
        " | serviceCount=" .. tostring(serviceValidationCount or 0) ..
        " | serviceMeanErrorSeconds=" .. tostring(serviceValidationHist and serviceValidationHist.meanErrorSeconds or nil) ..
        " | serviceMAESeconds=" .. tostring(serviceValidationHist and serviceValidationHist.meanAbsoluteErrorSeconds or nil) ..
        " | queueAdjustedServiceMeanErrorSeconds=" .. tostring(queueAdjustedServiceHist and queueAdjustedServiceHist.meanErrorSeconds or nil) ..
        " | queueAdjustedServiceMAESeconds=" .. tostring(queueAdjustedServiceHist and queueAdjustedServiceHist.meanAbsoluteErrorSeconds or nil))
  end

  return table.concat(lines, "\n")
end

function HarborArrivals:_LogSmallWarningTypeInfo(label, value)
  if value == nil then
    log("SMALL WARNING PROBE | label=" .. tostring(label) .. " | type=nil | value=nil")
    return
  end
  local info = getTypeInfoText(value)
  if info ~= nil then
    info = tostring(info):gsub("\r", " "):gsub("\n", " ")
  end
  log("SMALL WARNING PROBE | label=" .. tostring(label) ..
      " | luaType=" .. tostring(type(value)) ..
      " | value=" .. tostring(value) ..
      " | typeInfo=" .. tostring(info))
end


function HarborArrivals:_WriteCompactExplainerText()
  -- Runtime v0.1.31 proved that the compact native ExplainerPopup itself is
  -- exactly the desired warning surface, while Content:AddElement() is not
  -- exposed on the retail binding. Keep the warning intentionally title-only.
  local sceneData = safeCall(function()
    return ui.Scenes.ExplainerPopup.SceneData
  end)
  if sceneData == nil then return false, "scene-data-unavailable" end

  local header = safeGet(sceneData, "Header")
  if header == nil then return false, "header-unavailable" end
  local ok = pcall(function()
    header.Text = self:_T("harbor_not_selected")
  end)
  if not ok then return false, "header-write-failed" end

  if self.shortWarningApplied ~= true then
    log("COMPACT WARNING READY | reason=harbor-position-unavailable | header=" .. self:_T("harbor_not_selected") .. " | mode=title-only")
  end
  self.shortWarningApplied = true
  return true, nil
end

function HarborArrivals:ShowShortWarning(reason)
  self:_DetectUILanguage()
  self.liveDashboardActive = false
  self.pendingOpen = false
  self.opening = false
  self.reportApplied = false
  self.shortWarningApplied = false
  self.shortWarningOpening = false
  self.shortWarningTicks = 0
  self.shortWarningReason = tostring(reason or "warning")

  -- Seed the compact ExplainerPopup title before triggering the native action.
  -- v0.1.31 runtime proved the title-only surface is the desired UX.
  local prepared, prepareReason = self:_WriteCompactExplainerText()
  log("COMPACT WARNING PREPARE | success=" .. tostring(prepared) ..
      " | reason=" .. tostring(prepareReason))

  local ok, err = pcall(function()
    GovernorDecision:CheatStartGovernorDecisionForCurrentPlayerNet(self.SHORT_WARNING_STORYLINE_GUID)
  end)
  if not ok then
    self.shortWarningOpening = false
    log("COMPACT WARNING ERROR | reason=" .. tostring(self.shortWarningReason) .. " | " .. tostring(err))
    return false
  end

  log("COMPACT WARNING START | reason=" .. tostring(self.shortWarningReason) ..
      " | guid=" .. tostring(self.SHORT_WARNING_STORYLINE_GUID))
  return true
end

function HarborArrivals:QueuePopup()
  self:_DetectUILanguage()
  self.liveDashboardActive = false
  self.lastAppliedReportText = nil
  self.lastLiveRefreshMs = nil
  self.reportText = self:BuildReport()
  self.pendingOpen = true
  self.reportApplied = false
  self.openTicks = 0
end

function HarborArrivals:FinishScan(reason)
  if reason ~= nil then self.failureReason = tostring(reason) end

  local _, _, _, filter, _, buttons = getTradeRouteParts()
  local cleared = 0
  if buttons ~= nil then cleared = clearSelectedIslandButtons(buttons) end

  local popupVisible = safeGet(filter, "IsPopupVisible") == true
  local popupClosed = false
  if popupVisible and self.filterPopupOpenedByUs then
    local fn = safeGet(filter, "CloseButtonEvent")
    if type(fn) == "function" then
      popupClosed = pcall(function() return filter:CloseButtonEvent() end)
    end
  end

  local closeOk, closeResult = true, "not-opened-by-us"
  if self.tradeRouteOpenedByUs then
    closeOk, closeResult = openTradeRouteMenu()
  end

  log("TARGET FILTER CLEANUP | reason=" .. tostring(reason or "success") ..
      " | selectedCleared=" .. tostring(cleared) ..
      " | popupClosed=" .. tostring(popupClosed) ..
      " | tradeRouteCloseSuccess=" .. tostring(closeOk) ..
      " | tradeRouteCloseResult=" .. tostring(closeResult))

  self.scanStage = "cleanup_wait"
  self.scanTicks = 0
end

function HarborArrivals:_OpenBusyReason()
  if self.scanActive then return "scan-active" end
  if self.pendingOpen then return "popup-pending" end
  if self.opening then return "popup-opening" end
  return nil
end

function HarborArrivals:Open()
  local busyReason = self:_OpenBusyReason()
  if busyReason ~= nil then
    log("OPEN SHORTCUT | result=ignored | reason=" .. tostring(busyReason))
    return
  end
  log("OPEN SHORTCUT | result=accepted | bindingIdentifier=SirLocksleyHarborArrivalsOpen | invocationPath=native-shortcut")

  self.liveDashboardActive = false
  self.lastAppliedReportText = nil
  self.lastLiveRefreshMs = nil
  self.parchmentJumpEntries = {}

  local context, contextError = readSelectionContext()
  self.context = context
  self.routes = {}
  self.onboardCargoCache = {}
  self.failureReason = nil
  self.tradeRouteOpenedByUs = false
  self.filterPopupOpenedByUs = false
  self.motionSampleStartPlayTime = nil
  self.motionSampleMidPlayTime = nil
  self.movementTypeInfoSeen = {}

  if context == nil then
    self.failureReason = contextError
    if contextError == "harbor-position-unavailable" then
      self:ShowShortWarning(contextError)
    else
      self:QueuePopup()
    end
    log("OPEN REJECT | reason=" .. tostring(contextError))
    return
  end

  log("TARGET FILTER START | selectionGUID=" .. tostring(context.selectionGUID) ..
      " | selectionID=" .. tostring(context.selectionID) ..
      " | rawAreaID=" .. tostring(context.rawAreaID) ..
      " | islandAreaID=" .. tostring(context.islandAreaID) ..
      " | island=" .. tostring(context.islandName) ..
      " | harborX=" .. tostring(context.harborX) ..
      " | harborY=" .. tostring(context.harborY) ..
      " | harborZ=" .. tostring(context.harborZ))

  if contextError ~= nil then
    self.failureReason = contextError
    if contextError == "harbor-position-unavailable" then
      self:ShowShortWarning(contextError)
    else
      self:QueuePopup()
    end
    log("OPEN REJECT | reason=" .. tostring(contextError) .. " | selectionGUID=" .. tostring(context.selectionGUID) .. " | selectionID=" .. tostring(context.selectionID))
    return
  end

  self.scanActive = true
  self.scanStage = "begin"
  self.scanTicks = 0
end

function HarborArrivals:TickScan()
  self.scanTicks = self.scanTicks + 1

  if self.scanStage == "begin" then
    local scene, _, rows, _, _, _, panelOpen = getTradeRouteParts()
    local rowCount = countOverviewRows(rows)
    log("TARGET FILTER BASELINE | rows=" .. tostring(rowCount) .. " | panelOpen=" .. tostring(panelOpen))

    if panelOpen == true or rowCount > 0 then
      local ok, result = closeTradeRouteSceneForNormalize()
      log("TARGET FILTER NORMALIZE CLOSE | success=" .. tostring(ok) .. " | result=" .. tostring(result))
      self.scanStage = "normalize_wait"
      self.scanTicks = 0
      return
    end

    local ok, result = openTradeRouteMenu()
    log("TARGET FILTER OPEN | success=" .. tostring(ok) .. " | result=" .. tostring(result))
    if not ok then
      self:FinishScan("open-call-failed")
      return
    end
    self.tradeRouteOpenedByUs = true
    self.scanStage = "open_wait"
    self.scanTicks = 0
    return
  end

  if self.scanStage == "normalize_wait" then
    if self.scanTicks >= 1 then
      local ok, result = openTradeRouteMenu()
      log("TARGET FILTER NORMALIZE REOPEN | success=" .. tostring(ok) .. " | result=" .. tostring(result))
      if not ok then
        self:FinishScan("normalize-reopen-failed")
        return
      end
      self.tradeRouteOpenedByUs = true
      self.scanStage = "open_wait"
      self.scanTicks = 0
    end
    return
  end

  if self.scanStage == "open_wait" then
    local _, _, rows, _, _, _, panelOpen = getTradeRouteParts()
    local rowCount = countOverviewRows(rows)
    if panelOpen == true and rowCount > 0 then
      local expanded = expandCollapsedGroups(rows)
      log("TARGET FILTER OPENED | rows=" .. tostring(rowCount) .. " | groupsExpanded=" .. tostring(expanded))
      self.scanStage = "expand_wait"
      self.scanTicks = 0
      return
    end
    if self.scanTicks >= 12 then self:FinishScan("trade-route-open-timeout") end
    return
  end

  if self.scanStage == "expand_wait" then
    if self.scanTicks < 1 then return end
    local _, _, rows, filter, islandList, buttons = getTradeRouteParts()
    local rowCount = countOverviewRows(rows)
    if filter == nil or islandList == nil then
      self:FinishScan("filter-surface-unavailable")
      return
    end

    local visible = safeGet(filter, "IsPopupVisible") == true
    if not visible then
      local fn = safeGet(filter, "FilterButtonEvent")
      if type(fn) ~= "function" then
        self:FinishScan("FilterButtonEvent-unavailable")
        return
      end
      local ok, result = pcall(function() return filter:FilterButtonEvent() end)
      self.filterPopupOpenedByUs = ok
      log("TARGET FILTER POPUP OPEN | rows=" .. tostring(rowCount) .. " | success=" .. tostring(ok) .. " | result=" .. tostring(result))
      if not ok then
        self:FinishScan("filter-popup-open-failed")
        return
      end
    else
      log("TARGET FILTER POPUP REUSE | alreadyVisible=true")
    end
    self.scanStage = "filter_wait"
    self.scanTicks = 0
    return
  end

  if self.scanStage == "filter_wait" then
    local _, _, _, _, _, buttons = getTradeRouteParts()
    local target, list, size = findIslandButton(buttons, self.context.islandName)
    if size < 1 then
      if self.scanTicks < 4 then return end
      self:FinishScan("island-buttons-empty")
      return
    end

    log("TARGET FILTER ENUMERATE | nativeButtons=" .. tostring(size) .. " | namedButtons=" .. tostring(#list) .. " | island=" .. tostring(self.context.islandName) .. " | found=" .. tostring(target ~= nil))
    if target == nil then
      self:FinishScan("target-island-button-not-found")
      return
    end

    local cleared = clearSelectedIslandButtons(buttons)
    log("TARGET FILTER CLEAR | selectedCleared=" .. tostring(cleared))
    self.scanStage = "select_wait"
    self.scanTicks = 0
    return
  end

  if self.scanStage == "select_wait" then
    if self.scanTicks < 1 then return end
    local _, _, _, _, _, buttons = getTradeRouteParts()
    local target = findIslandButton(buttons, self.context.islandName)
    if target == nil then
      self:FinishScan("target-island-button-lost")
      return
    end
    local ok, result = pressButton(target.button)
    log("TARGET FILTER SELECT | island=" .. tostring(target.name) .. " | arrayIndex=" .. tostring(target.index) .. " | success=" .. tostring(ok) .. " | result=" .. tostring(result))
    if not ok then
      self:FinishScan("target-filter-select-failed")
      return
    end
    self.scanStage = "filtered_wait"
    self.scanTicks = 0
    return
  end

  if self.scanStage == "filtered_wait" then
    if self.scanTicks < 1 then return end
    local _, _, rows = getTradeRouteParts()
    local routes = harvestRouteRows(rows)
    for _, route in ipairs(routes) do
      route.ships = activeShipsForRoute(route.routeName, self.context)
      for _, ship in ipairs(route.ships) do
        log("SHIP | island=" .. tostring(self.context.islandName) ..
            " | routeID=" .. tostring(route.routeID) ..
            " | route=" .. tostring(route.routeName) ..
            " | name=" .. tostring(ship.name) ..
            " | status=" .. tostring(ship.status) ..
            " | id=" .. tostring(ship.idText) ..
            " | x=" .. tostring(ship.x) .. " | y=" .. tostring(ship.y) .. " | z=" .. tostring(ship.z) ..
            " | distance=" .. tostring(ship.distance))
      end
    end
    self.routes = routes

    local selectedIsHarvestedShip, selectedShip = selectionMatchesHarvestedShip(self.context, routes)
    if selectedIsHarvestedShip then
      log("SELECTION GUARD | result=ship-match-after-harvest | selectionID=" .. tostring(self.context.selectionID) ..
          " | ship=" .. tostring(selectedShip and selectedShip.name) ..
          " | route=" .. tostring(selectedShip and selectedShip.routeName))
      self:FinishScan("ship-selected-select-harbor")
      return
    end
    log("SELECTION GUARD | result=accepted-harbor-reference | selectionGUID=" .. tostring(self.context.selectionGUID) ..
        " | selectionID=" .. tostring(self.context.selectionID))

    for _, route in ipairs(routes) do
      for _, ship in ipairs(route.ships or {}) do
        self:_EnsureServiceWatch(route, ship)
      end
    end

    self.motionSampleStartPlayTime = getPlayTimeMs()
    self.motionSampleMidPlayTime = nil
    log("TARGET FILTER HARVEST | island=" .. tostring(self.context.islandName) .. " | routes=" .. tostring(#routes) ..
        " | motionSampleStartPlayTime=" .. tostring(self.motionSampleStartPlayTime))
    probeNonRouteShips(self.context, routes)
    self.scanStage = "motion_mid_wait"
    self.scanTicks = 0
    return
  end

  if self.scanStage == "motion_mid_wait" then
    local now = getPlayTimeMs()
    local elapsedMs = nil
    if type(now) == "number" and type(self.motionSampleStartPlayTime) == "number" then
      elapsedMs = now - self.motionSampleStartPlayTime
    end
    if type(elapsedMs) == "number" and elapsedMs < 850 and self.scanTicks < 4 then return end
    if elapsedMs == nil and self.scanTicks < 2 then return end

    self.motionSampleMidPlayTime = now
    for _, ship in ipairs(self.manualShipCandidates or {}) do
      local xm, ym, zm = getVectorCoordinates(safeGet(ship.object, "Position"))
      local dm = distanceFromHarbor(ship.object, self.context)
      ship.sampleMidX = xm
      ship.sampleMidY = ym
      ship.sampleMidZ = zm
      ship.sampleMidDistance = dm
      log("MANUAL SHIP MOTION MIDPOINT | island=" .. tostring(self.context.islandName) ..
          " | ship=" .. tostring(ship.name) ..
          " | id=" .. tostring(ship.idText) ..
          " | elapsedMs=" .. tostring(elapsedMs) ..
          " | distance=" .. tostring(dm))
    end
    for _, route in ipairs(self.routes or {}) do
      for _, ship in ipairs(route.ships or {}) do
        local xm, ym, zm = getVectorCoordinates(safeGet(ship.object, "Position"))
        local dm = distanceFromHarbor(ship.object, self.context)
        ship.sampleMidX = xm
        ship.sampleMidY = ym
        ship.sampleMidZ = zm
        ship.sampleMidDistance = dm
        log("MOTION MIDPOINT | island=" .. tostring(self.context.islandName) ..
            " | routeID=" .. tostring(route.routeID) ..
            " | route=" .. tostring(route.routeName) ..
            " | ship=" .. tostring(ship.name) ..
            " | elapsedMs=" .. tostring(elapsedMs) ..
            " | distance=" .. tostring(dm) ..
            " | x=" .. tostring(xm) .. " | z=" .. tostring(zm))
      end
    end
    self.scanStage = "motion_wait"
    self.scanTicks = 0
    return
  end

  if self.scanStage == "motion_wait" then
    local now = getPlayTimeMs()
    local elapsedMs = nil
    if type(now) == "number" and type(self.motionSampleStartPlayTime) == "number" then
      elapsedMs = now - self.motionSampleStartPlayTime
    end
    if type(elapsedMs) == "number" and elapsedMs < 1800 and self.scanTicks < 4 then return end
    if elapsedMs == nil and self.scanTicks < 2 then return end

    for _, route in ipairs(self.routes or {}) do
      for _, ship in ipairs(route.ships or {}) do
        local x2, y2, z2 = getVectorCoordinates(safeGet(ship.object, "Position"))
        local d2 = distanceFromHarbor(ship.object, self.context)
        ship.x = x2
        ship.y = y2
        ship.z = z2
        ship.distance = d2
        ship.motion = HarborArrivals._ComputeThreePointMotionMetrics(
          ship.sample1X, ship.sample1Z, ship.sample1Distance, self.motionSampleStartPlayTime,
          ship.sampleMidX, ship.sampleMidZ, ship.sampleMidDistance, self.motionSampleMidPlayTime,
          x2, z2, d2, now,
          self.ARRIVAL_RADIUS
        )
        log("MOTION | island=" .. tostring(self.context.islandName) ..
            " | routeID=" .. tostring(route.routeID) ..
            " | route=" .. tostring(route.routeName) ..
            " | ship=" .. tostring(ship.name) ..
            " | elapsedMs=" .. tostring(elapsedMs) ..
            " | d1=" .. tostring(ship.sample1Distance) ..
            " | dm=" .. tostring(ship.sampleMidDistance) ..
            " | d2=" .. tostring(d2) ..
            " | x1=" .. tostring(ship.sample1X) .. " | z1=" .. tostring(ship.sample1Z) ..
            " | xm=" .. tostring(ship.sampleMidX) .. " | zm=" .. tostring(ship.sampleMidZ) ..
            " | x2=" .. tostring(x2) .. " | z2=" .. tostring(z2) ..
            " | motion=" .. tostring(ship.motion.motion) ..
            " | speed=" .. tostring(ship.motion.speed) ..
            " | closingSpeed=" .. tostring(ship.motion.closingSpeed) ..
            " | alignment=" .. tostring(ship.motion.alignment) ..
            " | segment1ClosingSpeed=" .. tostring(ship.motion.segment1ClosingSpeed) ..
            " | segment2ClosingSpeed=" .. tostring(ship.motion.segment2ClosingSpeed) ..
            " | segment1Alignment=" .. tostring(ship.motion.segment1Alignment) ..
            " | segment2Alignment=" .. tostring(ship.motion.segment2Alignment) ..
            " | closingSpeedRelativeChange=" .. tostring(ship.motion.closingSpeedRelativeChange) ..
            " | weightedClosingSpeed=" .. tostring(ship.motion.weightedClosingSpeed) ..
            " | stability=" .. tostring(ship.motion.stability) ..
            " | etaReliable=" .. tostring(ship.motion.etaReliable) ..
            " | remainingDistanceToArrivalZone=" .. tostring(ship.motion.remainingDistanceToArrivalZone) ..
            " | projectedETASeconds=" .. tostring(ship.motion.projectedETASeconds))
        self:_ProbeMovementFactors(route, ship)
      end
    end
    self.manualShipResults = {}
    for _, ship in ipairs(self.manualShipCandidates or {}) do
      local x2, y2, z2 = getVectorCoordinates(safeGet(ship.object, "Position"))
      local d2 = distanceFromHarbor(ship.object, self.context)
      ship.x = x2
      ship.y = y2
      ship.z = z2
      ship.distance = d2
      ship.motion = HarborArrivals._ComputeThreePointMotionMetrics(
        ship.sample1X, ship.sample1Z, ship.sample1Distance, self.motionSampleStartPlayTime,
        ship.sampleMidX, ship.sampleMidZ, ship.sampleMidDistance, self.motionSampleMidPlayTime,
        x2, z2, d2, now,
        self.ARRIVAL_RADIUS
      )

      local atHarbor = type(d2) == "number" and d2 <= self.CARGO_SERVICE_START_RADIUS
      local approaching = ship.motion ~= nil
        and ship.motion.motion == "APPROACHING"
        and ship.motion.etaReliable == true
      local stationaryAtHarbor = atHarbor
        and ship.motion ~= nil
        and ship.motion.motion == "STATIONARY"
      local include = approaching

      if include then
        local predictedAtMs = now
        local predictedETASeconds = ship.motion.projectedETASeconds
        self.manualShipResults[#self.manualShipResults + 1] = {
          object = ship.object,
          name = ship.name,
          idText = ship.idText,
          status = ship.status,
          distance = d2,
          motion = ship.motion,
          etaSeconds = predictedETASeconds,
          predictedAtMs = predictedAtMs,
          predictedArrivalAtMs = (type(predictedAtMs) == "number" and type(predictedETASeconds) == "number")
            and (predictedAtMs + predictedETASeconds * 1000) or nil,
          atHarbor = false,
          manual = true,
        }
      elseif stationaryAtHarbor then
        self.manualShipsAtHarbor[#self.manualShipsAtHarbor + 1] = {
          object = ship.object,
          name = ship.name,
          idText = ship.idText,
          status = ship.status,
          distance = d2,
          motion = ship.motion,
          atHarbor = true,
          manual = true,
        }
      end

      log("MANUAL SHIP MOTION" ..
          " | island=" .. tostring(self.context and self.context.islandName) ..
          " | ship=" .. tostring(ship.name) ..
          " | id=" .. tostring(ship.idText) ..
          " | d1=" .. tostring(ship.sample1Distance) ..
          " | dm=" .. tostring(ship.sampleMidDistance) ..
          " | d2=" .. tostring(d2) ..
          " | motion=" .. tostring(ship.motion and ship.motion.motion) ..
          " | closingSpeed=" .. tostring(ship.motion and ship.motion.closingSpeed) ..
          " | alignment=" .. tostring(ship.motion and ship.motion.alignment) ..
          " | stability=" .. tostring(ship.motion and ship.motion.stability) ..
          " | etaReliable=" .. tostring(ship.motion and ship.motion.etaReliable) ..
          " | projectedETASeconds=" .. tostring(ship.motion and ship.motion.projectedETASeconds) ..
          " | predictedAtMs=" .. tostring(approaching and now or nil) ..
          " | predictedArrivalAtMs=" .. tostring(
              approaching and type(now) == "number" and type(ship.motion.projectedETASeconds) == "number"
                and (now + ship.motion.projectedETASeconds * 1000) or nil) ..
          " | atHarbor=" .. tostring(atHarbor) ..
          " | stationaryAtHarbor=" .. tostring(stationaryAtHarbor) ..
          " | include=" .. tostring(include) ..
          " | meaning=approaching manual ships go to manual arrivals; stationary ships at harbor go to HARBOR NOW")
    end

    table.sort(self.manualShipResults, function(a, b)
      local ea = tonumber(a.etaSeconds)
      local eb = tonumber(b.etaSeconds)
      if ea ~= nil and eb ~= nil then return ea < eb end
      if ea ~= nil then return true end
      if eb ~= nil then return false end
      return string.lower(tostring(a.name)) < string.lower(tostring(b.name))
    end)

    table.sort(self.manualShipsAtHarbor, function(a, b)
      return string.lower(tostring(a.name)) < string.lower(tostring(b.name))
    end)

    log("MANUAL SHIP RESULT SUMMARY | island=" .. tostring(self.context and self.context.islandName) ..
        " | candidates=" .. tostring(#(self.manualShipCandidates or {})) ..
        " | approachingIncluded=" .. tostring(#(self.manualShipResults or {})) ..
        " | stationaryAtHarbor=" .. tostring(#(self.manualShipsAtHarbor or {})) ..
        " | owner=" .. tostring(self.manualShipOwner))

    for _, route in ipairs(self.routes or {}) do
      local stationCount, validArgs, topologyError = HarborArrivals._ReadBackendStationCount(route.routeID)
      route.stationCount = stationCount
      route.topologyStatus = topologyError == nil and "backend-count" or ("backend-count-failed: " .. tostring(topologyError))
      local argParts = {}
      for _, value in ipairs(validArgs or {}) do argParts[#argParts + 1] = tostring(value) end
      log("BACKEND TOPOLOGY | island=" .. tostring(self.context.islandName) ..
          " | routeID=" .. tostring(route.routeID) ..
          " | route=" .. tostring(route.routeName) ..
          " | stationCount=" .. tostring(stationCount) ..
          " | validStationArgs=" .. table.concat(argParts, ",") ..
          " | error=" .. tostring(topologyError))
      for _, ship in ipairs(route.ships or {}) do
        ship.arrival = HarborArrivals._ClassifyArrival(ship, route, self.context and self.context.islandName)
        ship.arrival.capturedAtMs = now
        log("ARRIVAL CLASSIFICATION | island=" .. tostring(self.context and self.context.islandName) ..
            " | routeID=" .. tostring(route.routeID) ..
            " | route=" .. tostring(route.routeName) ..
            " | ship=" .. tostring(ship.name) ..
            " | stops=" .. tostring(route.stationCount) ..
            " | state=" .. tostring(ship.arrival.state) ..
            " | bucket=" .. tostring(ship.arrival.bucket) ..
            " | confidence=" .. tostring(ship.arrival.confidence) ..
            " | etaSeconds=" .. tostring(ship.arrival.etaSeconds) ..
            " | distance=" .. tostring(ship.distance) ..
            " | motion=" .. tostring(ship.motion and ship.motion.motion))
        self:_RecordEtaPrediction(route, ship)
      end
    end
    self:FinishScan(nil)
    return
  end

  if self.scanStage == "cleanup_wait" then
    if self.scanTicks >= 1 then
      self.scanActive = false
      self.scanStage = "idle"
      log("TARGET FILTER COMPLETE | island=" .. tostring(self.context and self.context.islandName) ..
          " | routes=" .. tostring(#(self.routes or {})) ..
          " | failure=" .. tostring(self.failureReason))
      self:QueuePopup()
    end
  end
end

function HarborArrivals:StartPopup()
  self.pendingOpen = false
  self.opening = true
  self.openTicks = 0
  local ok, err = pcall(function()
    GovernorDecision:CheatStartGovernorDecisionForCurrentPlayerNet(self.STORYLINE_GUID)
  end)
  if not ok then
    self.opening = false
    log("STORYLINE ERROR | " .. tostring(err))
  else
    log("STORYLINE STARTED | guid=" .. tostring(self.STORYLINE_GUID))
  end
end

function HarborArrivals:_ApplyTextPopupPanel()
  local panel = safeCall(function()
    return ui.Scenes.TextPopup.SceneData.Panel
  end)
  if panel == nil then return false end
  local ok, err = pcall(function()
    panel.IsVisible = self.panelVisible == true
    if self.panelVisible == true then
      panel.HeaderText = tostring(self.panelHeaderText or "")
      panel.DescriptionText = tostring(self.panelDescriptionText or "")
    end
  end)
  if not ok then
    log("POPUP PANEL ERROR | " .. tostring(err))
    return false
  end
  return true
end

function HarborArrivals:ApplyPopupText()
  local content = safeCall(function()
    return ui.Scenes.TextPopup.SceneData.Content
  end)
  if content == nil then return false end

  -- The TextPopup asset starts with localized LineId 2006999900. Read that native
  -- text before overwriting it, exactly like Ship Finder's proven localized-marker
  -- pattern, then rebuild the report in the detected language.
  self:_DetectUILanguage(safeGet(content, "Text"))
  self.reportText = self:BuildReport()
  local text = self.reportText or self:_T("no_report_data")
  local ok, err = pcall(function()
    content.Text = text
  end)
  if not ok then
    log("POPUP TEXT ERROR | " .. tostring(err))
    return false
  end
  self:_ApplyTextPopupPanel()
  self.reportApplied = true
  self.opening = false
  self.liveDashboardActive = true
  self.lastAppliedReportText = text
  self.lastLiveRefreshMs = getPlayTimeMs()
  log("POPUP READY | liveDashboard=true | refreshIntervalMs=" .. tostring(self.LIVE_REFRESH_INTERVAL_MS))
  return true
end

function HarborArrivals:RefreshLiveDashboard()
  if self.liveDashboardActive ~= true or self.scanActive or self.pendingOpen or self.opening then return false end
  -- TextPopup.SceneData.Panel.IsVisible is the visibility of the optional
  -- information panel inside the TextPopup, not visibility of the TextPopup scene itself.
  -- Runtime v0.1.26 proved it can be false while the parchment is visibly open.
  -- Protect foreign popups by content ownership below instead of using that flag.
  local content = safeCall(function()
    return ui.Scenes.TextPopup.SceneData.Content
  end)
  if content == nil then
    self.liveDashboardActive = false
    log("LIVE DASHBOARD STOP | reason=text-popup-unavailable")
    return false
  end

  local currentText = safeGet(content, "Text")
  local now = getPlayTimeMs()
  local decision = self._LiveRefreshDecision(
    self.liveDashboardActive, currentText, self.lastAppliedReportText, now, self.lastLiveRefreshMs, self.LIVE_REFRESH_INTERVAL_MS
  )
  if decision == "WAIT" then return false end
  if decision == "STOP" then
    self.liveDashboardActive = false
    log("LIVE DASHBOARD STOP | reason=popup-content-changed")
    return false
  end

  local nextText = self:BuildReport()
  local ok, err = pcall(function() content.Text = nextText end)
  if not ok then
    self.liveDashboardActive = false
    log("LIVE DASHBOARD STOP | reason=text-update-error | error=" .. tostring(err))
    return false
  end
  self.reportText = nextText
  self.lastAppliedReportText = nextText
  self:_ApplyTextPopupPanel()
  self.lastLiveRefreshMs = now
  return true
end

function HarborArrivals:Tick()
  self:UpdateServiceWatches()

  if self.scanActive then
    self:TickScan()
    return
  end

  if self.pendingOpen then
    self:StartPopup()
    return
  end

  if self.opening and not self.reportApplied then
    self.openTicks = self.openTicks + 1
    if self:ApplyPopupText() then return end
    if self.openTicks > 80 then
      self.opening = false
      log("POPUP TIMEOUT | could not access TextPopup.SceneData.Content")
    end
    return
  end

  if self.liveDashboardActive then
    self:RefreshLiveDashboard()
  end
end

function HarborArrivals:Load()
  log("LOADED | identifier=SirLocksleyHarborArrivalsOpen | default=Ctrl+Alt+H | rightPanel=arrivals+onboard cargo | parchment=harbor operations+ship jump | languages=en,de,fr | deepDiagnostics=false")
end

return HarborArrivals
