import java.util.Iterator;
import java.util.List;

class EnemyManager {

  List<Enemy> enemies;
  
  public EnemyManager() {
    this.enemies = new ArrayList<>();
  }
  
  public Enemy createEnemy(float x, float y, float speed, int team) {
    Enemy enemy = new Enemy(x, y, speed, team);
    this.enemies.add(enemy);
    return enemy;
  }
  
  public int enemyCount() {
    return this.enemies.size();
  }
  
  public void removeEnemy(Enemy enemy) {
    this.enemies.get(this.enemies.indexOf(enemy)).health = 0;
  }
  
  public void boidStep(float deltatime) {
    Iterator<Enemy> iterator = enemies.iterator();
    while (iterator.hasNext()) {
      Enemy enemy = iterator.next();
      if (enemy.health <= 0) {
        iterator.remove();
      } else {
        enemy.startPhysics();
        enemy.align(this.getEnemies(enemy.blockGrid.x, enemy.blockGrid.y, 400), 5);
        enemy.cohesion(this.getEnemies(enemy.blockGrid.x, enemy.blockGrid.y, 400), 1);
        enemy.seperation(this.getEnemies(enemy.blockGrid.x, enemy.blockGrid.y, 100), 5);
        enemy.target(1);
        enemy.seperation(this.getEnemies(enemy.blockGrid.x, enemy.blockGrid.y, 100), 25);

      }
    }
  }
  
  public void update(float deltatime) {
    this.boidStep(deltatime);
    Iterator<Enemy> iterator = enemies.iterator();
    while (iterator.hasNext()) {
      Enemy enemy = iterator.next();
      if (enemy.health <= 0) {
        iterator.remove();
      } else {
        enemy.update(deltatime);
      }
    }
  }
  
  public ArrayList<Enemy> getEnemies(float x, float y, float radius) {
    ArrayList<Enemy> enemies = new ArrayList<Enemy>();
    for (Enemy enemy : this.enemies) {
      if (this.distance(enemy.blockGrid.x, enemy.blockGrid.y, x, y) < radius) {
        enemies.add(enemy);
      }
    }
    
    return enemies;
  }
  
  public void show(float deltatime) {
    fill(255, 0, 0);
    strokeWeight(0);
    for (Enemy enemy : this.enemies) {
      enemy.show(deltatime);
    }
  }

  public void randomizeShootTime() {
    for (Enemy enemy : this.enemies) {
      enemy.blockGrid.randomizeShootTime();
    }
  }

  public void shoot(boolean state) {
    if (state) {
      for (Enemy enemy : this.enemies) {
        enemy.shoot();
      }
    }
  }
  
  public float distance(float x1, float y1, float x2, float y2) {
    return sqrt(pow(x1 - x2, 2) + pow(y1 - y2, 2));
  }
  
  public ArrayList<Enemy> hit(float x, float y, float radius) {
    ArrayList<Enemy> hitEnemies = new ArrayList<>();
    for (Enemy enemy : this.enemies) {
      if (distance(enemy.blockGrid.x, enemy.blockGrid.y, x, y) < radius + (enemy.blockGrid.radius.x + enemy.blockGrid.radius.y)) {
        hitEnemies.add(enemy);
      }
    }
    
    return hitEnemies;
  }
  
}
