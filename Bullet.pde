
class Bullet {
  
  public int team, damage;
  public float x, y, angle, speed;
  
  public int pierce = 15;
  public int lifetime;
  
  public boolean deleted = false;

  public Bullet(float x, float y, float angle, float speed, int team, int lifetime, int damage) {
    this.x = x;
    this.y = y;
    this.angle = angle;
    this.speed = speed;
    this.team = team;
    this.lifetime = lifetime;
    this.damage = damage;
  }
  
  public void update(float deltatime) {
    this.lifetime -= 1;
    if (this.lifetime <= 0 || this.pierce <= 0) {
      this.deleted = true;
      return;
    }
    this.speed *= 0.95;
    this.x = this.x + sin(this.angle) * this.speed;
    this.y = this.y + cos(this.angle) * this.speed;
    
    if (this.team == 1) {
      ArrayList<Enemy> hitEnemies = enemyManager.hit(this.x, this.y, this.speed);
      for (Enemy enemy : hitEnemies) {
        if (enemy == null) {
          continue;
        }
        
        if (this.pierce <= 0) {
          continue;
        }
        
        enemy.health -= this.damage * (0.8 + (this.speed / 10));
        this.pierce -= 1;
        this.speed *= 0.9;
      }
    }
  }
  
  public void show(float deltatime) {
    PVector position = worldToScreen(new PVector(this.x, this.y));
    
    line(position.x, position.y, position.x + sin(this.angle) * this.speed, position.y + cos(this.angle) * this.speed);
  }
  
}
