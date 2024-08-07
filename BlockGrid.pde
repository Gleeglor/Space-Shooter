
public class Block {
  
  public int x, y;
  public BlockGrid blockGrid;
  public ArrayList<BlockComponent> components;
  
  public Block(int x, int y, BlockGrid blockGrid) {
    this.x = x;
    this.y = y;
    this.blockGrid = blockGrid;
    this.components = new ArrayList<BlockComponent>();
  }
  
  public void update(float deltatime) {
    for (BlockComponent component : this.components) {
      component.update(deltatime);
    }
  }
  
  public void show(float deltatime) {
    int tileSize = this.blockGrid.tileSize;
    worldRect(this.getPosition(), new PVector(tileSize, tileSize));
    
    for (BlockComponent component : this.components) {
      component.show(deltatime);
    }
  }
  
  public PVector getPosition() {
    float x = this.x * this.blockGrid.tileSize + this.blockGrid.x;
    float y = this.y * this.blockGrid.tileSize + this.blockGrid.y;
    
    return new PVector(x, y);
  }
  
}

public class BlockGrid {
  
  public float x, y;
  public int tileSize;
  
  public int team;
  
  public PVector center, radius;
  
  public ArrayList<Block> blocks;
  public ArrayList<Turret> turrets;
  
  public BlockGrid(float x, float y, int tileSize, int team) {
    this.team = team;
    this.x = x;
    this.y = y;
    this.tileSize = tileSize;
    this.blocks = new ArrayList<Block>();
    this.turrets = new ArrayList<Turret>();
  }
  
  public void recalculateCenter() {
    float x = 0;
    float y = 0;
    
    for (Block block : this.blocks) {
      x += block.x / 2;
      y += block.y / 2;
    }
    
    x *= this.tileSize;
    y *= this.tileSize;
    
    this.center = new PVector(x, y);
  }
  
  public void recalculateRadius() {
    float minX = 0, maxX = 0;
    float minY = 0, maxY = 0;
    
    for (Block block : this.blocks) {
      minX = min(minX, block.x);
      minY = min(minY, block.y);
      maxX = max(maxX, block.x);
      maxY = max(maxY, block.y);
    }
    
    float x = abs(minX + maxX);
    float y = abs(minY + maxY);
    
    x *= this.tileSize;
    y *= this.tileSize;
    
    this.radius = new PVector(x, y);
  }
  
  public Block createBlock(int x, int y) {
    Block block = new Block(x, y, this);
    this.blocks.add(block);
    this.recalculateCenter();
    this.recalculateRadius();
    return block;
  }
  
  public Turret createTurret(int x, int y) {
    return this.createTurret(x, y, TurretType.BASIC);
  }
  
  public Turret createTurret(int x, int y, TurretType type) {
    Block block = this.createBlock(x, y);
    
    return this.createTurret(block, type);
  }
  
  public Turret createTurret(Block block, TurretType type) {
    int damage = 0;
    float reloadTime = 1000;
    switch (type) {
      case BASIC:
      damage = 40;
      reloadTime = 1000;
      break;
    }
  
    return createTurret(block, damage, reloadTime);
  }
  
  public Turret createTurret(Block block, int damage, float reloadTime) {  
    Turret turret = new Turret(block, damage, reloadTime);
    this.turrets.add(turret);
    block.components.add(turret);
    return turret;
  }
  
  public void shoot(float x, float y) {
    for (Turret turret : this.turrets) {
      turret.shoot(x, y);
    }
  }
  
  public void randomizeShootTime() {
    for (Turret turret : this.turrets) {
      turret.canShoot = false;
      turret.timer = random(turret.reloadTime);
    }
  }
  
  public void update(float deltatime) {
    for (Block block : this.blocks) {
      block.update(deltatime);
    }
  }
  
  public void show(float deltatime) {
    for (Block block : this.blocks) {
      block.show(deltatime);
    }
  }
  
}
