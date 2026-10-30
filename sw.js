/* Service worker: red primero (así se actualiza siempre) y copia local si no hay conexión */
const C='scouting-pub-v91';
self.addEventListener('install',e=>{self.skipWaiting();e.waitUntil(caches.open(C).then(c=>c.addAll(['./','./index.html','./manifest.webmanifest','./icon-192.png','./icon-512.png'])).catch(()=>{}));});
self.addEventListener('activate',e=>{e.waitUntil(caches.keys().then(k=>Promise.all(k.filter(x=>x!==C).map(x=>caches.delete(x)))).then(()=>self.clients.claim()));});
self.addEventListener('fetch',e=>{
  const r=e.request; if(r.method!=='GET'||new URL(r.url).origin!==location.origin) return;
  if(/\/(ffmpeg|ai)\//.test(r.url)){ e.respondWith(caches.match(r).then(m=>m||fetch(r).then(res=>{ if(res.ok&&(+res.headers.get('content-length')||99999)>1000){ const cp=res.clone(); caches.open(C).then(c=>c.put(r,cp)); } return res; }))); return; }
  e.respondWith(fetch(r,{cache:'no-store'}).then(res=>{const cp=res.clone(); caches.open(C).then(c=>c.put(r,cp)); return res;}).catch(()=>caches.match(r).then(m=>m||caches.match('./index.html'))));
});
