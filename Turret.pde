
enum TurretType {
  BASIC,
}

class Turret implements BlockComponent { 
  
  Block block;
  
  int damage;
  float reloadTime;
  float timer = 0;
  
  PVector target;
  
  boolean canShoot = false;
  
  public Turret(Block block, int damage, float reloadTime) {
    this.block = block;
    this.damage = damage;
    this.reloadTime = reloadTime;
  }
  
  public void update(float deltatime) {
    if (!this.canShoot) {
      this.timer = this.timer + (int)deltatime;
      if (this.timer > this.reloadTime) {
        this.timer = 0;
        this.canShoot = true;
      }
    }
  }
  
  public void setTarget(PVector position) {
    this.target = position;
  }
  
  float angle;
  public void show(float deltatime) {
    PVector position = this.block.getPosition();
    
    PVector offset = new PVector(0, 8);
    PVector size = new PVector(2, 16);
    worldRectRotate(position, size, this.angle, offset);
  }
  
  public void shoot(float targetX, float targetY) {
    this.setTarget(new PVector(targetX, targetY));
    if (!this.canShoot) {
      return;
    }
    
    this.canShoot = false;
    PVector position = this.block.getPosition();
    
    this.angle = PI+atan2(position.x - this.target.x, position.y - this.target.y);
    
    bulletManager.createBullet(position.x, position.y, this.angle, 35, this.block.blockGrid.team, 40, this.damage);
  }
  
}
