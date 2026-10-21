+++
title = "The Monty Hall problem, simulated"
+++

A prize sits behind one of three doors. You pick a door. The host then opens
one of the two doors you did not pick, and it turns out to be empty. Should you
switch to the remaining closed door?

Switching wins two times in three, and the reason is the host's knowledge. A
host who knows where the prize is never opens its door, so the door left closed
carries information. A host who opens a door at random might have revealed the
prize; when the prize happens to stay hidden, the host's choice tells you
nothing, and switching wins only half the time.

Play the game many times below and watch the shares of wins settle.

<div id="mh">
  <div class="mh-controls">
    <label>Episodes <input id="mh-n" type="range" min="30" max="3000" step="30" value="3000">
      <output id="mh-n-out">3000</output></label>
    <button id="mh-run" type="button">Play</button>
  </div>
  <canvas id="mh-plot" width="700" height="420" aria-label="Share of wins against number of episodes"></canvas>
  <ul class="mh-legend">
    <li><span style="background:#d1495b"></span>host knows, stay</li>
    <li><span style="background:#00798c"></span>host knows, switch</li>
    <li><span style="background:#edae49"></span>host picks at random, stay</li>
    <li><span style="background:#66a182"></span>host picks at random, switch</li>
  </ul>
  <p id="mh-summary"></p>
</div>

With a random host, the shares count only the episodes in which the prize was
not revealed: those are the only ones where the contestant faces the same
choice.

I wrote this for first-year statistics at UCL in 2020; the original is in R
([montyhall.R](/content/montyhall.R)).

<style>
#mh { margin: 1.5em 0; }
.mh-controls { display: flex; gap: 1em; align-items: center; flex-wrap: wrap; margin-bottom: .5em; }
.mh-controls input { vertical-align: middle; }
.mh-controls output { display: inline-block; min-width: 3em; }
#mh-plot { width: 100%; height: auto; border: 1px solid #e5e5e5; }
.mh-legend { list-style: none; padding: 0; display: flex; flex-wrap: wrap; gap: .4em 1.2em; font-size: 13px; }
.mh-legend span { display: inline-block; width: 12px; height: 12px; margin-right: 5px; vertical-align: -1px; }
#mh-summary { font-size: 14px; }
</style>

<script>
(() => {
  const COLORS = ["#d1495b", "#00798c", "#edae49", "#66a182"];
  const canvas = document.getElementById("mh-plot");
  const ctx = canvas.getContext("2d");
  const slider = document.getElementById("mh-n");
  const out = document.getElementById("mh-n-out");
  const summary = document.getElementById("mh-summary");
  const pick3 = () => Math.floor(Math.random() * 3);
  let timer = null;

  // One episode of each game. The random host's episode is null when he
  // opens the prize door: the contestant never faces the choice.
  function episode() {
    const prize = pick3(), first = pick3();
    const others = [0, 1, 2].filter((d) => d !== first);
    const knowsOpens = others.filter((d) => d !== prize)[Math.floor(Math.random() * (first === prize ? 2 : 1))];
    const knowsLeft = others.find((d) => d !== knowsOpens);
    const randomOpens = others[Math.floor(Math.random() * 2)];
    const randomLeft = others.find((d) => d !== randomOpens);
    return {
      knowsStay: first === prize, knowsSwitch: knowsLeft === prize,
      random: randomOpens === prize ? null : { stay: first === prize, switch: randomLeft === prize },
    };
  }

  function draw(series, total) {
    const W = canvas.width, H = canvas.height, L = 48, R = 24, T = 12, B = 36;
    const x = (i) => L + (W - L - R) * i / Math.max(total, 1);
    const y = (v) => T + (H - T - B) * (1 - v);
    ctx.clearRect(0, 0, W, H);
    ctx.font = "12px sans-serif";
    ctx.fillStyle = "#666";
    ctx.strokeStyle = "#ccc";
    ctx.lineWidth = 1;
    for (const v of [0, 1 / 3, 0.5, 2 / 3, 1]) {
      ctx.beginPath(); ctx.moveTo(L, y(v)); ctx.lineTo(W - R, y(v)); ctx.stroke();
      ctx.textAlign = "right";
      ctx.fillText(v === 1 / 3 ? "1/3" : v === 2 / 3 ? "2/3" : String(v), L - 6, y(v) + 4);
    }
    ctx.textAlign = "center";
    for (let k = 0; k <= 4; k++) {
      const n = Math.round(total * k / 4);
      ctx.fillText(String(n), x(n), H - B + 16);
    }
    ctx.fillText("episodes played", (L + W - R) / 2, H - 4);
    series.forEach((s, j) => {
      ctx.strokeStyle = COLORS[j];
      ctx.lineWidth = 2;
      ctx.beginPath();
      s.forEach(([i, v], k) => (k ? ctx.lineTo(x(i), y(v)) : ctx.moveTo(x(i), y(v))));
      ctx.stroke();
    });
  }

  function run() {
    clearInterval(timer);
    const total = +slider.value;
    const step = Math.max(1, Math.round(total / 300));
    const wins = [0, 0, 0, 0];
    let played = 0, valid = 0;
    const series = [[], [], [], []];
    timer = setInterval(() => {
      for (let k = 0; k < step && played < total; k++) {
        const e = episode();
        played++;
        wins[0] += e.knowsStay; wins[1] += e.knowsSwitch;
        if (e.random) { valid++; wins[2] += e.random.stay; wins[3] += e.random.switch; }
        series[0].push([played, wins[0] / played]);
        series[1].push([played, wins[1] / played]);
        if (valid) {
          series[2].push([played, wins[2] / valid]);
          series[3].push([played, wins[3] / valid]);
        }
      }
      draw(series, total);
      const pct = (v) => (100 * v).toFixed(1) + "%";
      summary.textContent = `After ${played} episodes: with a host who knows, switching won ${pct(wins[1] / played)}; `
        + `with a random host, switching won ${valid ? pct(wins[3] / valid) : "–"} of the ${valid} episodes where the prize stayed hidden.`;
      if (played >= total) clearInterval(timer);
    }, 16);
  }

  slider.oninput = () => { out.value = slider.value; };
  document.getElementById("mh-run").onclick = run;
  run();
})();
</script>
