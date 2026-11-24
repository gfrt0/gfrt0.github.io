+++
title = "Talk timer"
description = "A section-by-section timer for talks: plan how long each part should take, then see the time left in the current section and how far ahead or behind the overall plan you are."
+++

Split a talk into sections, give each a time, and run through them. The big
number is the time left in the current section; it turns amber near the end
and red once you overrun. Pace tracks how far ahead or behind the overall plan
you are. Your sections are saved in this browser.

<div id="tt">
  <div class="tt-top">
    <button id="tt-edit" type="button">Edit sections</button>
    <button id="tt-compact" type="button">Compact</button>
    <button id="tt-full" type="button">Fullscreen</button>
  </div>

  <div id="tt-run">
    <div class="tt-now">
      <div class="tt-label" id="tt-pos">Ready</div>
      <div class="tt-name" id="tt-cur">&nbsp;</div>
      <div class="tt-big" id="tt-big">0:00</div>
      <div class="tt-bar"><div id="tt-bar"></div></div>
      <div class="tt-stats">
        <span>Elapsed <b id="tt-tot">0:00</b> / <span id="tt-plan">0:00</span></span>
        <span class="tt-pace ok" id="tt-pace">on time</span>
      </div>
    </div>
    <div class="tt-btns">
      <button class="tt-primary" id="tt-start" type="button">Start</button>
      <button id="tt-prev" type="button">◀ Prev</button>
      <button id="tt-next" type="button">Next ▶</button>
      <button id="tt-reset" type="button">Reset</button>
    </div>
    <ol id="tt-list"></ol>
    <p class="tt-hint">Space starts or pauses; the arrow keys move between sections; click a row to jump to it.</p>
  </div>

  <div id="tt-editor" hidden>
    <p class="tt-hint">One section per line: <b>name, time</b>. Time can be minutes (<b>5</b>), minutes and seconds (<b>2:30</b> or <b>2m30s</b>), or seconds (<b>45s</b>).</p>
    <textarea id="tt-ta" spellcheck="false"></textarea>
    <div class="tt-row">
      <label><input type="checkbox" id="tt-auto"> Move on automatically when a section ends</label>
      <label>Warn at <input type="number" id="tt-warn" min="0" max="600" step="5"> s left</label>
    </div>
    <div class="tt-btns">
      <button class="tt-primary" id="tt-save" type="button">Save</button>
      <button id="tt-cancel" type="button">Cancel</button>
    </div>
  </div>
</div>

<style>
#tt { --tt-line: #e5e5e5; --tt-muted: #777; --tt-acc: #00798c; --tt-ok: #3a8f5c; --tt-warn: #c98a12; --tt-bad: #d1495b;
  margin: 1.5em 0; max-width: 560px; background: #fff; }
#tt button { background: #fff; color: inherit; border: 1px solid var(--tt-line); border-radius: 6px;
  padding: 6px 10px; font: inherit; font-size: 14px; cursor: pointer; }
#tt button:hover { border-color: #bbb; }
#tt button.tt-primary { background: var(--tt-acc); border-color: var(--tt-acc); color: #fff; }
.tt-top, .tt-btns { display: flex; gap: 6px; flex-wrap: wrap; margin-bottom: 10px; }
.tt-now { border: 1px solid var(--tt-line); border-radius: 8px; padding: 14px 16px; margin-bottom: 10px; }
.tt-label { font-size: 13px; color: var(--tt-muted); }
.tt-name { font-size: 20px; font-weight: 600; margin: 2px 0 4px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.tt-big { color: #222; font-variant-numeric: tabular-nums; font-size: 64px; font-weight: 700; line-height: 1.1; }
.tt-big.warn { color: var(--tt-warn); } .tt-big.bad { color: var(--tt-bad); }
.tt-bar { height: 6px; background: var(--tt-line); border-radius: 3px; overflow: hidden; margin-top: 10px; }
.tt-bar > div { height: 100%; width: 0; background: var(--tt-acc); }
.tt-stats { display: flex; justify-content: space-between; margin-top: 10px; font-size: 13px; color: var(--tt-muted); font-variant-numeric: tabular-nums; }
.tt-pace { font-weight: 600; }
.tt-pace.ok { color: var(--tt-ok); } .tt-pace.behind { color: var(--tt-bad); } .tt-pace.ahead { color: var(--tt-warn); }
#tt-list { list-style: none; margin: 0; padding: 0; border: 1px solid var(--tt-line); border-radius: 8px; overflow: hidden; }
#tt-list li { display: grid; grid-template-columns: 22px 1fr auto auto; gap: 10px; align-items: center; margin: 0;
  padding: 8px 12px; border-top: 1px solid var(--tt-line); font-size: 14px; font-variant-numeric: tabular-nums; cursor: pointer; position: relative; }
#tt-list li:first-child { border-top: none; }
#tt-list .n, #tt-list .plan { color: var(--tt-muted); font-size: 12px; }
#tt-list .t { white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
#tt-list .act { min-width: 58px; text-align: right; }
#tt-list li.done { color: var(--tt-muted); }
#tt-list li.done .act.over { color: var(--tt-bad); } #tt-list li.done .act.under { color: var(--tt-ok); }
#tt-list li.cur { background: #eef6f7; } #tt-list li.cur .t { font-weight: 600; }
#tt-list .fill { position: absolute; left: 0; bottom: 0; height: 2px; background: var(--tt-acc); }
.tt-hint { font-size: 13px; color: var(--tt-muted); margin: 10px 0; }
#tt-ta { width: 100%; box-sizing: border-box; min-height: 220px; border: 1px solid var(--tt-line); border-radius: 6px;
  padding: 10px; font: 14px/1.5 ui-monospace, Menlo, Consolas, monospace; }
#tt-warn { width: 60px; }
.tt-row { display: flex; gap: 12px; flex-wrap: wrap; margin: 8px 0; font-size: 13px; color: var(--tt-muted); }
#tt.compact { max-width: 320px; }
#tt.compact .tt-big { font-size: 44px; }
#tt.compact #tt-list li { padding: 5px 10px; font-size: 13px; }
#tt.compact .tt-hint { display: none; }
#tt:fullscreen { max-width: none; margin: 0; padding: 4vh 6vw; overflow: auto; }
#tt:fullscreen .tt-big { font-size: 22vh; }
#tt:fullscreen .tt-name { font-size: 4vh; }
@media (max-width: 480px) {
  #tt .tt-big { font-size: 22vw; }
  #tt button { padding: 10px 14px; font-size: 15px; }
}
</style>

<script>
(() => {
  const DEFAULT = "Opening, 2\nThe problem, 5\nThe method, 8\nCase study, 7\nResults, 5\nQ&A, 8";
  const KEY = "talkTimerCfg";
  const $ = (id) => document.getElementById("tt-" + id);
  const root = document.getElementById("tt");
  let cfg = { text: DEFAULT, auto: false, warn: 30 };
  try { const s = localStorage.getItem(KEY); if (s) cfg = Object.assign(cfg, JSON.parse(s)); } catch (e) {}

  let segs = [], actual = [];  // planned and spent seconds per section
  let cur = 0, running = false, started = false, finished = false, lastTick = 0;

  function parse(text) {
    return text.split("\n").map((l) => l.trim()).filter(Boolean).map((l) => {
      const i = l.lastIndexOf(",");
      const name = i >= 0 ? l.slice(0, i).trim() : l, t = i >= 0 ? l.slice(i + 1).trim() : "5";
      const ms = t.toLowerCase().replace(/\s+/g, "").match(/^(?:(\d+(?:[.,]\d+)?)m(?:in)?)?(?:(\d+)s(?:ec)?)?$/);
      let sec;
      if (t.includes(":")) { const [m, s] = t.split(":"); sec = (+m || 0) * 60 + (+s || 0); }
      else if (ms && (ms[1] || ms[2])) sec = Math.round(parseFloat((ms[1] || "0").replace(",", ".")) * 60) + (+ms[2] || 0);
      else sec = Math.round((parseFloat(t.replace(",", ".")) || 0) * 60);
      return { name: name || "Section", dur: Math.max(1, sec) };
    });
  }
  function fmt(s) {
    const neg = s < 0; s = Math.abs(Math.round(s));
    const h = Math.floor(s / 3600), m = Math.floor(s % 3600 / 60), x = s % 60;
    return (neg ? "−" : "") + (h ? h + ":" + String(m).padStart(2, "0") : m) + ":" + String(x).padStart(2, "0");
  }
  const sum = (a) => a.reduce((x, y) => x + y, 0);

  function load() {
    segs = parse(cfg.text); actual = segs.map(() => 0);
    cur = 0; running = false; started = false; finished = false;
    keepAwake(false);
    const ol = $("list"); ol.innerHTML = "";
    segs.forEach((s, i) => {
      const li = document.createElement("li");
      li.innerHTML = `<span class="n">${i + 1}</span><span class="t"></span><span class="plan">${fmt(s.dur)}</span><span class="act"></span><span class="fill"></span>`;
      li.querySelector(".t").textContent = s.name;
      li.onclick = () => { finished = false; cur = i; started = true; render(); };
      ol.appendChild(li);
    });
    render();
  }

  function render() {
    if (!segs.length) return;
    const s = segs[cur], spent = actual[cur], left = s.dur - spent;
    const state = left < 0 ? "bad" : left <= cfg.warn ? "warn" : "";
    $("pos").textContent = finished ? "Finished" : `Section ${cur + 1} of ${segs.length}` + (running ? "" : started ? " · paused" : " · ready");
    $("cur").textContent = finished ? "Done" : s.name;
    $("big").textContent = finished ? fmt(sum(actual)) : fmt(left);
    $("big").className = "tt-big" + (finished || !state ? "" : " " + state);
    $("bar").style.width = Math.min(100, spent / s.dur * 100) + "%";
    $("bar").style.background = `var(--tt-${state || "acc"})`;
    $("tot").textContent = fmt(sum(actual));
    $("plan").textContent = fmt(sum(segs.map((x) => x.dur)));

    // Pace: overrun or underrun of completed sections, plus any overrun of the current one
    let delta = 0;
    for (let i = 0; i < cur; i++) delta += actual[i] - segs[i].dur;
    if (finished) delta += actual[cur] - segs[cur].dur;
    else if (left < 0) delta -= left;
    const p = $("pace");
    if (Math.abs(delta) < 5) { p.textContent = "on time"; p.className = "tt-pace ok"; }
    else if (delta > 0) { p.textContent = fmt(delta) + " behind"; p.className = "tt-pace behind"; }
    else { p.textContent = fmt(-delta) + " ahead"; p.className = "tt-pace ahead"; }

    $("start").textContent = running ? "Pause" : started && !finished ? "Resume" : "Start";

    [...$("list").children].forEach((li, i) => {
      const done = finished || i < cur;
      li.className = i === cur && !finished ? "cur" : done ? "done" : "";
      const a = li.querySelector(".act");
      if (done || (i === cur && actual[i] > 0)) {
        a.textContent = fmt(actual[i]);
        a.className = "act" + (done ? (actual[i] > segs[i].dur + 4 ? " over" : actual[i] < segs[i].dur - 4 ? " under" : "") : "");
      } else { a.textContent = ""; a.className = "act"; }
      li.querySelector(".fill").style.width = i === cur && !finished ? Math.min(100, actual[i] / segs[i].dur * 100) + "%" : "0";
    });
  }

  function tick() {
    if (running) {
      const now = performance.now();
      actual[cur] += (now - lastTick) / 1000; lastTick = now;
      if (cfg.auto && actual[cur] >= segs[cur].dur) {
        const extra = actual[cur] - segs[cur].dur; actual[cur] = segs[cur].dur;
        if (cur < segs.length - 1) { cur++; actual[cur] += extra; }
        else { running = false; finished = true; keepAwake(false); }
      }
      render();
    }
    requestAnimationFrame(tick);
  }

  // Keep a phone screen awake while the timer runs, where the browser allows it
  let wake = null;
  async function keepAwake(on) {
    try {
      if (on && !wake && navigator.wakeLock) { wake = await navigator.wakeLock.request("screen"); wake.addEventListener("release", () => { wake = null; }); }
      else if (!on && wake) { await wake.release(); wake = null; }
    } catch (e) { wake = null; }
  }
  document.addEventListener("visibilitychange", () => { if (document.visibilityState === "visible" && running) keepAwake(true); });

  function toggle() {
    if (finished) return;
    running = !running; started = true; lastTick = performance.now(); keepAwake(running); render();
  }
  function next() {
    if (finished) return;
    started = true;
    if (cur < segs.length - 1) cur++;
    else { running = false; finished = true; keepAwake(false); }
    lastTick = performance.now(); render();
  }
  function prev() {
    if (finished) { finished = false; render(); return; }
    if (cur > 0) cur--;
    lastTick = performance.now(); render();
  }
  const showEditor = (on) => { $("editor").hidden = !on; $("run").hidden = on; };

  $("start").onclick = toggle; $("next").onclick = next; $("prev").onclick = prev; $("reset").onclick = load;
  $("edit").onclick = () => {
    $("ta").value = cfg.text; $("auto").checked = cfg.auto; $("warn").value = cfg.warn;
    showEditor(true);
  };
  $("cancel").onclick = () => showEditor(false);
  $("save").onclick = () => {
    cfg.text = $("ta").value.trim() || DEFAULT; cfg.auto = $("auto").checked; cfg.warn = Math.max(0, +$("warn").value || 0);
    try { localStorage.setItem(KEY, JSON.stringify(cfg)); } catch (e) {}
    showEditor(false); load();
  };
  $("compact").onclick = () => root.classList.toggle("compact");
  $("full").onclick = () => {
    try {
      if (document.fullscreenElement) document.exitFullscreen();
      else root.requestFullscreen().catch(() => {});
    } catch (e) {}
  };
  document.addEventListener("keydown", (e) => {
    if (!$("editor").hidden || e.target.closest("input, textarea, select")) return;
    if (e.code === "Space") {
      e.preventDefault();
      if (document.activeElement && document.activeElement.tagName === "BUTTON") document.activeElement.blur();
      toggle();
    } else if (e.key === "ArrowRight") next();
    else if (e.key === "ArrowLeft") prev();
  });

  load(); requestAnimationFrame(tick);
})();
</script>
