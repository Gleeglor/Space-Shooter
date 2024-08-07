
class Enemy {
  
  public int team, health;
  public float speed = 5;
  public BlockGrid blockGrid;
  public PVector acceleration;
  
  public boolean deleted = false;
  public Player target;

  public Enemy(float x, float y, float speed, int team) {
    this.acceleration = new PVector(random(1)-0.5, random(1)-0.5);
    this.blockGrid = new BlockGrid(x, y, 15, 2);
    this.speed = speed;
    this.team = team;
    this.health = 100;
    
    this.blockGrid.createTurret(0, 0);
    
    this.target = player;
  }
  
  public void startPhysics() {
    this.acceleration = new PVector();
  }
  
  public void align(ArrayList<Enemy> enemies, float strength) {
    PVector steering = new PVector();
    for (Enemy enemy : enemies) {
      if (enemy == this) {
        continue;
      }
      
      steering.add(new PVector(enemy.acceleration.x, enemy.acceleration.y));
    }
    int total = enemies.size();
    
    if (total > 0) {
      steering.div(total);
      steering.mult(this.speed);
      steering.sub(this.acceleration);
      steering.mult(strength);
      steering.limit(this.speed);
    }
    
    this.acceleration.add(steering);
  }
  
  public void cohesion(ArrayList<Enemy> enemies, float strength) {
    PVector steering = new PVector();
    for (Enemy enemy : enemies) {
      if (enemy == this) {
        continue;
      }
      
      steering.add(new PVector(enemy.blockGrid.x, enemy.blockGrid.y));
    }
    int total = enemies.size();
    
    if (total > 0) {
      steering.div(total);
      steering.sub(new PVector(this.blockGrid.x, this.blockGrid.y));
      steering.mult(this.speed);
      steering.sub(this.acceleration);
      steering.mult(strength);
      steering.limit(this.speed);
    }
    
    this.acceleration.add(steering);
  }
  
  public void seperation(ArrayList<Enemy> enemies, float strength) {
    PVector steering = new PVector();
    for (Enemy enemy : enemies) {
      if (enemy == this) {
        continue;
      }
      
      PVector otherPos = new PVector(enemy.blockGrid.x, enemy.blockGrid.y);
      PVector thisPos = new PVector(this.blockGrid.x, this.blockGrid.y);
      float distance = 0.001f + thisPos.dist(otherPos);
      PVector difference = thisPos.sub(otherPos);
      difference.div(distance);
      steering.add(difference);
    }
    int total = enemies.size();
    
    if (total > 0) {
      steering.div(total);
      steering.mult(this.speed);
      steering.sub(this.acceleration);
      steering.mult(strength);
      steering.limit(this.speed);
    }
    
    this.acceleration.add(steering);
  }
  
  public void target(float strength) {
    PVector steering = new PVector();
    
    steering.sub(new PVector(this.blockGrid.x - this.target.blockGrid.x, this.blockGrid.y - this.target.blockGrid.y));
    steering.limit(this.speed);
    steering.mult(strength);
    
    this.acceleration.add(steering);
  }
  
  public void shoot() {
    this.blockGrid.shoot(this.target.blockGrid.x, this.target.blockGrid.y);
  }
  
  public void update(float deltatime) {
    this.blockGrid.update(deltatime);
    
    //float angle = PI + atan2() + this.avoidAngle;
    this.acceleration.limit(this.speed);

    this.blockGrid.x += this.acceleration.x;
    this.blockGrid.y += this.acceleration.y;
  }
  
  public void show(float deltatime) {
    this.blockGrid.show(deltatime);
  }
}
