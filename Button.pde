
public class Button {
  
  PVector position;
  PVector size;
  
  color standardColor, highlightColor, clickColor;
  
  boolean hover = false, clicked = false, newClick = false;
  
  Button(PVector position, PVector size) {
    this.position = position;
    this.size = size;
    
    this.standardColor = color(51);
    this.highlightColor = color(120);
    this.clickColor = color(200);
  }
  
  public void update() {
    if (this.overRect(this.position, this.size) ) {
      this.hover = true;
      if (mousePressed) {
        if (newClick == false && this.clicked == false) {
          this.newClick = true; 
        } else {
          this.newClick = false;
        }
        
        this.clicked = true;
      } else {
        this.clicked = false;
      }
    } else {
      this.hover = false;
    }
  }
  
  public void show() {
    if (this.newClick) {
      fill(clickColor);
    } else {
      if (this.hover) {
        fill(highlightColor);
      } else {
        fill(standardColor);
      }
    }
    
    stroke(255);
    rect(this.position.x, this.position.y, this.size.x, this.size.y);
  }
  
  boolean overRect(PVector position, PVector size)  {
    if (mouseX >= position.x - size.x / 2 && mouseX <= position.x + size.x / 2 && 
        mouseY >= position.y - size.y / 2 && mouseY <= position.y + size.y / 2) {
      return true;
    } else {
      return false;
    }
  }
}
