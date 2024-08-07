
class Player {
  
  public BlockGrid blockGrid;
  
  public int team;
  public float speed;
  public PVector acceleration;
  
  public List<Turret> turrets;
  
  public boolean isMoving, isShooting = false;
  
  public Player(float x, float y) {
    this.speed = 10;
    this.blockGrid = new BlockGrid(x, y, 10, 1);
    
    this.acceleration = new PVector(0, 0);

    this.blockGrid.createBlock(0, 0);
    this.blockGrid.createTurret(3, 1);
    this.blockGrid.createTurret(-3, 1);
  }
  
  //public void simpleTurretStart() {
  //  this.turrets.add(turretManager.createTurret(-3, 1, this.tileSize, TurretType.BASIC));
  //  this.turrets.add(turretManager.createTurret(3, 1, this.tileSize, TurretType.BASIC));
  //}
  
  //public void createCircleTurret() {
  //  float radius = 5;
  //  int complexity = 16;
    
  //  float ang_delta = TWO_PI/float(complexity);
    
  //  for (int i = 0; i < complexity; i++) {
  //    float ang = ang_delta * i;
  //    float j = sin(ang) * radius;
  //    float k = cos(ang) * radius;
      
  //    this.turrets.add(turretManager.createTurret(round(j), round(k), this.tileSize, TurretType.BASIC));
  //  }
  //}
  
  public void show(float deltatime) {
    fill(millis()/5%255);
    strokeWeight(0);
    rectMode(CENTER);
    
    this.blockGrid.show(deltatime);
  }
  
  public void update(float deltatime) {
    if (this.isMoving) {
      this.move();
      this.isMoving = false;
    }
    
    if (this.isShooting) {
      this.shoot();
      this.isShooting = false;
    }
    
    this.blockGrid.update(deltatime);
  }
  
  public void shoot() {
    this.blockGrid.shoot(camera.x + mouseX - width / 2, camera.y + mouseY - height / 2);
  }
  
  public void input(HashMap<Character, Boolean> keys) {
    this.acceleration = new PVector(0, 0);
    for (Character k : keys.keySet()) {
      boolean state = keys.get(k);
      if (!state) {
        continue;
      }
      print(k);
      this.isMoving = true;
      switch (k) {
        case 'w': this.acceleration.y = -1; break;
        case 's': this.acceleration.y = 1; break;
        case 'a': this.acceleration.x = -1; break;
        case 'd': this.acceleration.x = 1; break;
        default: break;
      }
    }
  }
  
  public void mouseInput(HashMap<Integer, Boolean> mouse) {
    for (Integer m : mouse.keySet()) {
      boolean state = mouse.get(m);
      if (!state) {
        continue;
      }
      
      if (m == LEFT) {
        this.isShooting = true;
      }
      if (m == RIGHT) {
        
      }
    }
  }
  
  public void move() {
    acceleration.normalize();
    
    this.blockGrid.x += acceleration.x * this.speed;
    this.blockGrid.y += acceleration.y * this.speed;
  }
  
}
