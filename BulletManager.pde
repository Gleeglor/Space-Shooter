import java.util.Iterator;
import java.util.List;

class BulletManager {

  List<Bullet> bullets;
  
  public BulletManager() {
    this.bullets = new ArrayList<>();
  }
  
  public Bullet createBullet(float x, float y, float angle, float speed, int team, int lifetime, int damage) {
    Bullet bullet = new Bullet(x, y, angle, speed, team, lifetime, damage);
    this.bullets.add(bullet);
    bullet.show(0);
    return bullet;
  }
  
  public void removeBullet(Bullet bullet) {
    this.bullets.remove(bullet);
  }
  
  public void update(float deltatime) {
    Iterator<Bullet> iterator = bullets.iterator();
    while (iterator.hasNext()) {
        Bullet bullet = iterator.next();
        if (bullet.deleted) {
            iterator.remove();
        } else {
            bullet.update(deltatime);
        }
    }
  }
  
  public void show(float deltatime) {
    push();
    stroke(255);
    strokeWeight(cameraZoom*5);
    for (Bullet bullet : this.bullets) {
      bullet.show(deltatime);
    }
    pop();
  }
  
}
