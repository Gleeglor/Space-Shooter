
Player player;
HashMap<Character, Boolean> keys;
HashMap<Integer, Boolean> mouse;
BulletManager bulletManager;
EnemyManager enemyManager;
float ups = 20;
float spu = 1000/ups;
Button button;

public void setup() {
  bulletManager = new BulletManager();
  enemyManager = new EnemyManager();
  player = new Player(0, 0);
  keys = new HashMap<>();
  mouse = new HashMap<>();
  button = new Button(new PVector(25, 25), new PVector(50, 50));
  size(1200, 900);
}

float cameraZoom = 1;
float cameraPanningSpeed = 8;
PVector camera = new PVector(0, 0);

float time = 0;
float fixed_deltatime = 0;
float deltatime = 0;
int index = 0;
public void draw() {
  strokeWeight(0);
  stroke(255);
  fill(255);
  background(0);
  
  deltatime = millis() - time;
  time = millis();
  
  update(deltatime);
  render(deltatime);
}

public void worldRectRotate(PVector position, PVector size, float angle, PVector offset) {
    push();
    fill(255);
    PVector screenPosition = worldToScreen(position);
    PVector screenSize = worldToScreenScale(size);
    
    translate(screenPosition.x, screenPosition.y);
    rotate(-angle);
    translate(offset.x, offset.y);
    rect(0, 0, screenSize.x, screenSize.y);
    
    pop();
}

public PVector worldToScreen(PVector position) {
  position.sub(camera);
  position.mult(cameraZoom);
  position.add(new PVector(width / 2, height / 2));
  return position;
}

public PVector worldToScreenScale(PVector position) {
  position.mult(cameraZoom);
  return position;
}

public PVector screenToWorld(PVector position) {
  return worldToScreen(position);
}

public void worldRect(PVector position, PVector size) {
  PVector screenPosition = worldToScreen(position);
  PVector screenSize = worldToScreenScale(size);
  
  rect(screenPosition.x, screenPosition.y, screenSize.x, screenSize.y);
}

float scroll = 0;
float enemyTimer = 0;
float enemyTimerMax = 1000/25f;
public void update(float deltatime) {
  player.input(keys);
  player.mouseInput(mouse);
  player.update(deltatime);
  
  button.update();
  button.show();
  
  PVector playerPos = new PVector(player.blockGrid.x, player.blockGrid.y);
  
  
  camera.x -= (camera.x - playerPos.x) * deltatime / 1000 * cameraPanningSpeed;
  camera.y -= (camera.y - playerPos.y) * deltatime / 1000 * cameraPanningSpeed;
  cameraZoom = max(0.5f, min(1f, scroll));
  
  bulletManager.update(deltatime);
  enemyManager.update(deltatime);
  
  enemyTimer += deltatime;
  while (enemyTimer > enemyTimerMax && enemyManager.enemyCount() < 200) {
    float ang = random(PI*2);
    
    enemyTimer -= enemyTimerMax;
    
    enemyManager.createEnemy(sin(ang) * width / 2, cos(ang) * height / 2, 5, 2);
    index = 0;
  }
  
  fixed_deltatime = 0;
}

boolean shootState = false;
public void render(float deltatime) {
  player.show(deltatime);
  
  bulletManager.show(deltatime);
  enemyManager.show(deltatime);
  if (button.newClick) {
    shootState = !shootState;
    enemyManager.randomizeShootTime();
  }
  enemyManager.shoot(shootState);
}

public void keyPressed() {
  keys.put(Character.toLowerCase(key), true);
}

public void keyReleased() {
  keys.put(Character.toLowerCase(key), false);
}

public void mousePressed() {
  mouse.put(mouseButton, true);
}

public void mouseReleased() {
  mouse.put(mouseButton, false);
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  scroll = e;
}
