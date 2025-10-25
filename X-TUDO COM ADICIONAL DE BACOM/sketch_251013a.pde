import java.util.ArrayList;
import java.util.Collections;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.Locale;

// =========================================================================
// CLASSE PARA O FUNDO DE ESTRELAS DO MENU
// =========================================================================
class Star {
  float x, y, z;
  Star() { 
    x = random(-width, width); 
    y = random(-height, height); 
    z = random(width);
  }
  void update() { 
    z = z - 2; 
    if (z < 1) { 
      z = width; 
      x = random(-width, width); 
      y = random(-height, height);
    }
  }
  void show() { 
    fill(255); 
    noStroke(); 
    float sx = map(x / z, 0, 1, 0, width); 
    float sy = map(y / z, 0, 1, 0, height); 
    float r = map(z, 0, width, 4, 0); 
    ellipse(sx, sy, r, r);
  }
}

// =========================================================================
// GERENCIADOR PRINCIPAL DO APLICATIVO
// =========================================================================

final int STATE_MENU = 0;
final int STATE_SEGMENT_DIVISION = 1;
final int STATE_PI_APPROXIMATION = 2;
final int STATE_CONTINUITY = 3; 
final int STATE_ARCHERY = 4;
int currentState = STATE_MENU;

SegmentDivisionSketch segmentSketch;
PiApproximationSketch piSketch;
ContinuitySketch continuitySketch; 
ArcherySketch archerySketch;

float buttonWidth = 400;
float buttonHeight = 60;
float buttonY_1, buttonY_2, buttonY_3, buttonY_4;
Star[] stars = new Star[400];

// =========================================================================
// SETUP PRINCIPAL
// =========================================================================
void setup() {
  size(1280, 800);
  smooth(8);

  segmentSketch = new SegmentDivisionSketch();
  piSketch = new PiApproximationSketch();
  continuitySketch = new ContinuitySketch(); 
  archerySketch = new ArcherySketch();

  float totalButtonHeight = (buttonHeight * 4) + (30 * 3);
  float startY = height/2 - totalButtonHeight/2;
  buttonY_1 = startY + buttonHeight/2;
  buttonY_2 = buttonY_1 + buttonHeight + 30;
  buttonY_3 = buttonY_2 + buttonHeight + 30;
  buttonY_4 = buttonY_3 + buttonHeight + 30;
  
  for (int i = 0; i < stars.length; i++) { 
    stars[i] = new Star();
  }
}

// =========================================================================
// DRAW PRINCIPAL
// =========================================================================
void draw() {
  switch (currentState) {
  case STATE_MENU:
    drawMenu();
    break;
  case STATE_SEGMENT_DIVISION:
    segmentSketch.updateAndDraw();
    drawBackButton();
    break;
  case STATE_PI_APPROXIMATION:
    piSketch.updateAndDraw();
    drawBackButton();
    break;
  case STATE_CONTINUITY: 
    continuitySketch.updateAndDraw();
    drawBackButton();
    break;
  case STATE_ARCHERY:
    archerySketch.updateAndDraw();
    drawBackButton();
    break;
  }
}

// =========================================================================
// MOUSEPRESSED PRINCIPAL
// =========================================================================
void mousePressed() {
  switch (currentState) {
  case STATE_MENU:
    checkMenuClicks();
    break;
  case STATE_SEGMENT_DIVISION:
    if (isBackButtonClicked()) { 
      currentState = STATE_MENU;
    } else { 
      segmentSketch.handleMousePress();
    }
    break;
  case STATE_PI_APPROXIMATION:
    if (isBackButtonClicked()) { 
      currentState = STATE_MENU;
    } else { 
      piSketch.handleMousePress();
    }
    break;
  case STATE_CONTINUITY: 
    if (isBackButtonClicked()) { 
      currentState = STATE_MENU;
    } else { 
      continuitySketch.handleMousePress();
    }
    break;
  case STATE_ARCHERY: 
    if (isBackButtonClicked()) { 
      currentState = STATE_MENU;
    } else { 
      archerySketch.handleMousePress();
    }
    break;
  }
}

// =========================================================================
// MOUSEWHEEL PRINCIPAL
// =========================================================================
void mouseWheel(MouseEvent event) {
  if (currentState == STATE_CONTINUITY) {
    continuitySketch.handleMouseWheel(event);
  }
  if (currentState == STATE_ARCHERY) {
    archerySketch.handleMouseWheel(event);
  }
}

// =========================================================================
// FUNÇÕES DO MENU (Sem alterações)
// =========================================================================
void drawStarfield() {
  translate(width / 2, height / 2);
  for (Star star : stars) { 
    star.update(); 
    star.show();
  }
  resetMatrix();
}
void drawMenu() {
  background(10, 15, 25);
  drawStarfield();
  textAlign(CENTER, CENTER);
  fill(240, 200); 
  textSize(24);
  text("PROJETOS DE VISUALIZAÇÃO", width / 2, height * 0.20 - 40);
  fill(240); 
  textSize(52);
  text("Menu Principal", width / 2, height * 0.20);
  drawButton("1. Divisão de Segmentos", width / 2, buttonY_1, buttonWidth, buttonHeight);
  drawButton("2. Aproximação de Pi", width / 2, buttonY_2, buttonWidth, buttonHeight);
  drawButton("3. Continuidade (ε-δ)", width / 2, buttonY_3, buttonWidth, buttonHeight); 
  drawButton("4. Arqueiro (ε-δ)", width / 2, buttonY_4, buttonWidth, buttonHeight);
}
void drawButton(String label, float x, float y, float w, float h) {
  boolean isHovering = (mouseX > x - w/2 && mouseX < x + w/2 && mouseY > y - h/2 && mouseY < y + h/2);
  rectMode(CENTER); 
  strokeWeight(2);
  if (isHovering) { 
    fill(0, 220, 255, 40); 
    stroke(0, 220, 255);
  } else { 
    noFill(); 
    stroke(100, 110, 120);
  }
  rect(x, y, w, h, 10);
  if (isHovering) { 
    fill(0, 220, 255);
  } else { 
    fill(230, 180);
  }
  textSize(22); 
  textAlign(CENTER, CENTER); 
  text(label, x, y - 2);
}
void checkMenuClicks() {
  if (mouseX > width/2 - buttonWidth/2 && mouseX < width/2 + buttonWidth/2 && 
    mouseY > buttonY_1 - buttonHeight/2 && mouseY < buttonY_1 + buttonHeight/2) {
    segmentSketch.resetSegment(); 
    currentState = STATE_SEGMENT_DIVISION;
  }
  if (mouseX > width/2 - buttonWidth/2 && mouseX < width/2 + buttonWidth/2 && 
    mouseY > buttonY_2 - buttonHeight/2 && mouseY < buttonY_2 + buttonHeight/2) {
    piSketch.start(); 
    currentState = STATE_PI_APPROXIMATION;
  }
  if (mouseX > width/2 - buttonWidth/2 && mouseX < width/2 + buttonWidth/2 && 
    mouseY > buttonY_3 - buttonHeight/2 && mouseY < buttonY_3 + buttonHeight/2) {
    continuitySketch.start(true); 
    currentState = STATE_CONTINUITY;
  }
  if (mouseX > width/2 - buttonWidth/2 && mouseX < width/2 + buttonWidth/2 && 
    mouseY > buttonY_4 - buttonHeight/2 && mouseY < buttonY_4 + buttonHeight/2) {
    archerySketch.resetArrow();
    currentState = STATE_ARCHERY;
  }
}
void drawBackButton() {
  rectMode(CORNER);
  boolean isHovering = (mouseX > 15 && mouseX < 115 && mouseY > height - 55 && mouseY < height - 15);
  if (isHovering) { 
    fill(255, 80, 80, 200); 
    stroke(255, 150, 150);
  } else { 
    fill(255, 80, 80, 50); 
    stroke(255, 80, 80, 180);
  }
  strokeWeight(2); 
  rect(15, height - 55, 100, 40, 8);
  if (isHovering) { 
    fill(255);
  } else { 
    fill(230);
  }
  textSize(20); 
  textAlign(CENTER, CENTER); 
  text("Menu", 65, height - 37);
}
boolean isBackButtonClicked() { 
  return (mouseX > 15 && mouseX < 115 && mouseY > height - 55 && mouseY < height - 15);
}


// #########################################################################
// # PROJETO 1: DIVISÃO DE SEGMENTOS (CÓDIGO INALTERADO)
// #########################################################################
class SegmentDivisionSketch {
  // ... (código original inalterado) ...
  DecimalFormat intFormatter, decFormatter; int gameState = 0; double segmentMin = 0, segmentMax = 1024; int cutCount = 0, maxCuts = 4; ArrayList<Double> allMarkers = new ArrayList<Double>(); float segmentWidthPixels; double x1, x2, y1, y2; double focal = 600, cameraZ = 0; PVector cameraOffset = new PVector(0, 0); double currentWorldWidth, totalScale = 1.0; boolean animatingCut = false; double cutProgress = 0, cutDuration = 60; double fromX2, toX2; boolean animatingZoom = false; double zoomProgress = 0, zoomDuration = 120; double startCameraZ, endCameraZ; PVector startOffset, endOffset; float flash = 0; color bgColor, lineColor, pointColor, textColor, flashColor;
  SegmentDivisionSketch() { segmentWidthPixels = width * 0.9f; intFormatter = new DecimalFormat("#"); String pattern = "0.################"; decFormatter = new DecimalFormat(pattern); DecimalFormatSymbols symbols = new DecimalFormatSymbols(new Locale("pt", "BR")); decFormatter.setDecimalFormatSymbols(symbols); bgColor = color(0); lineColor = color(255); pointColor = color(255, 60, 60); textColor = color(230); flashColor = color(255); resetSegment(); }
  void updateAndDraw() { noStroke(); fill(bgColor, 60); rect(0, 0, width, height); if (gameState == 1) { updateAnimation(); } flash = lerp(flash, 0, 0.1); drawSegmentAndMarkers(); if (gameState == 0) { fill(230, 150); textAlign(CENTER, CENTER); textSize(24); text("Clique para iniciar", width / 2, height / 2 - 40); } }
  void handleMousePress() { if (gameState == 0) { gameState = 1; startCut(); } else { resetSegment(); } }
  void resetSegment() { gameState = 0; x1 = 0; x2 = segmentMax; y1 = 0; y2 = 0; currentWorldWidth = segmentMax; totalScale = 1.0; cutCount = 0; cameraZ = 0; cameraOffset.set((float)(segmentMax / 2.0), 0); animatingCut = false; animatingZoom = false; allMarkers.clear(); allMarkers.add(Double.valueOf(0.0)); allMarkers.add(Double.valueOf(segmentMax)); }
  void updateAnimation() { if (animatingCut) { cutProgress += 1.0 / cutDuration; if (cutProgress >= 1.0) { finishCut(); } } else if (animatingZoom) { zoomProgress += 1.0 / zoomDuration; double t = easeInOutCubicDouble(zoomProgress); cameraZ = lerpDouble(startCameraZ, endCameraZ, t); cameraOffset.x = lerp(startOffset.x, endOffset.x, (float)t); if (zoomProgress >= 1.0) { animatingZoom = false; cutCount = 0; flash = 1.0; startCut(); } } }
  void startCut() { animatingCut = true; animatingZoom = false; cutProgress = 0; fromX2 = x2; toX2 = x1 + (x2 - x1) / 2.0; }
  void finishCut() { animatingCut = false; cutProgress = 0; x2 = toX2; flash = 1.0; if (!allMarkers.contains(x2)) { allMarkers.add(Double.valueOf(x2)); } cutCount++; if (cutCount >= maxCuts) { startNextZoom(); } else { startCut(); } }
  void startNextZoom() { animatingZoom = true; animatingCut = false; zoomProgress = 0; double targetWidth = x2; startCameraZ = cameraZ; startOffset = cameraOffset.copy(); double scaleFactorForThisStep = currentWorldWidth / targetWidth; totalScale *= scaleFactorForThisStep; endCameraZ = focal - (focal / totalScale); endOffset = new PVector((float)(targetWidth / 2.0), 0); currentWorldWidth = targetWidth; }
  void drawSegmentAndMarkers() { color currentLineColor = lerpColor(lineColor, flashColor, flash); stroke(currentLineColor); strokeWeight(4); PVector p1 = project(x1, y1); PVector p2; if (animatingCut) { double t = easeInOutCubicDouble(cutProgress); double currentX2 = lerpDouble(fromX2, toX2, t); p2 = project(currentX2, y2); } else { p2 = project(x2, y2); } line(p1.x, p1.y, p2.x, p2.y); Collections.sort(allMarkers); float lastLabelX = -1000; float minLabelSpacing = 45; for (Double markValue : allMarkers) { drawPoint(markValue); PVector p = project(markValue, 0); if (abs(p.x - lastLabelX) > minLabelSpacing) { String label = (markValue < 1 && markValue > 0) ? decFormatter.format(markValue) : intFormatter.format(markValue); drawLabel(markValue, label); lastLabelX = p.x; } } }
  PVector project(double x, double y) { double scale = (focal > cameraZ) ? focal / (focal - cameraZ) : 10000; double projectedX = (x - cameraOffset.x) * scale; float screenX = (width / 2.0f) + (float)(projectedX * (segmentWidthPixels / segmentMax)); float screenY = height / 2.0f + (float)y; return new PVector(screenX, screenY); }
  void drawPoint(double value) { PVector p = project(value, 0); color currentPointColor = lerpColor(pointColor, flashColor, flash); fill(currentPointColor); noStroke(); ellipse(p.x, p.y, 10, 10); }
  void drawLabel(double value, String label) { PVector p = project(value, 0); stroke(textColor, 150); strokeWeight(1); line(p.x, p.y - 6, p.x, p.y + 6); fill(textColor); textAlign(CENTER, TOP); textSize(14); text(label, p.x, p.y + 10); }
  double lerpDouble(double start, double stop, double amt) { return start + (stop - start) * amt; }
  double easeInOutCubicDouble(double t) { if (t < 0) t = 0; if (t > 1) t = 1; return t < 0.5 ? 4 * t * t * t : 1 - Math.pow(-2 * t + 2, 3) / 2; }
}


// #########################################################################
// # PROJETO 2: APROXIMAÇÃO DE PI (COM CORREÇÃO)
// #########################################################################
class PiApproximationSketch {
  class Particle { 
    PVector pos, vel; 
    float lifespan, baseSize; 
    Particle(PVector origin) { 
      pos = origin.copy(); 
      vel = PVector.random2D().mult(random(1, 4)); 
      lifespan = 255; 
      baseSize = random(2, 5);
    } 
    void update() { 
      pos.add(vel); 
      vel.mult(0.98); 
      lifespan -= 4;
    } 
    void display() { 
      noStroke(); 
      fill(255, lifespan); 
      ellipse(pos.x, pos.y, baseSize, baseSize);
    } 
    boolean isDead() { 
      return lifespan < 0;
    }
  }
  int gameState = 0; 
  int n; 
  float radius; 
  float rotationOffset = -HALF_PI; 
  PVector ballPos, ballVel; 
  float ballRadius = 8; 
  int bounceCooldown = 0; 
  int bounceCooldownTime = 15; 
  float flash = 0; 
  color bgColor, circleColor, inscribedColor, circumscribedColor, ballColor, textColor, flashColor; 
  double targetPiApproximation, displayedPiApproximation; 
  DecimalFormat piFormatter; 
  String formulaText = ""; 
  PVector[] inscribedVertices; 
  ArrayList<Particle> particles = new ArrayList<Particle>(); 
  float baseSpeed = 2.5; 
  float accelerationFactor = 0.1;
  PiApproximationSketch() { 
    bgColor = color(0); 
    circleColor = color(80); 
    inscribedColor = color(255); 
    circumscribedColor = color(255, 120); 
    ballColor = color(255, 60, 60); 
    textColor = color(230); 
    flashColor = color(255); 
    String pattern = "0.000000000"; 
    piFormatter = new DecimalFormat(pattern); 
    DecimalFormatSymbols symbols = new DecimalFormatSymbols(new Locale("pt", "BR")); 
    piFormatter.setDecimalFormatSymbols(symbols); 
    radius = height * 0.35;
  }
  void start() { 
    startSimulation();
  }
  void updateAndDraw() { 
    noStroke(); 
    rectMode(CORNER); 
    fill(bgColor, 40); 
    rect(0, 0, width, height); 
    translate(width / 2, height / 2); 
    if (gameState == 1) { 
      if (bounceCooldown > 0) bounceCooldown--; 
      moveBall(); 
      checkCollisions(); 
      updateTransitions(); 
      manageParticles();
    } 
    drawPolygons(); 
    drawBall(); 
    if (gameState == 0) { 
      fill(textColor, 200); 
      textAlign(CENTER, CENTER); 
      textSize(28); 
      text("Clique para iniciar", 0, 0);
    } 
    drawUI();
  }
  void handleMousePress() { 
    if (gameState == 0) { 
      gameState = 1;
    } else { 
      startSimulation();
    }
  }
  void startSimulation() { 
    gameState = 0; 
    n = 3; 
    ballPos = new PVector(0, 0); 
    ballVel = PVector.random2D().mult(calculateCurrentSpeed()); 
    updatePolygonVertices(); 
    targetPiApproximation = calculatePi(); 
    displayedPiApproximation = targetPiApproximation; 
    bounceCooldown = 0; 
    particles.clear(); 
    updateFormulaText();
  }
  float calculateCurrentSpeed() { 
    return baseSpeed + (n * accelerationFactor);
  }
  void moveBall() { 
    ballPos.add(ballVel); // CORREÇÃO: Usar ballVel em vez de vel
    if (ballPos.mag() > radius - ballRadius) { 
      ballPos.setMag(radius - ballRadius); 
      ballVel.mult(-1);
    }
  }
  void checkCollisions() { 
    if (inscribedVertices == null || bounceCooldown > 0) return; 
    for (int i = 0; i < n; i++) { 
      PVector v1 = inscribedVertices[i]; 
      PVector v2 = inscribedVertices[i + 1]; 
      if (pointLineDistance(ballPos, v1, v2) < ballRadius) { 
        PVector side = PVector.sub(v2, v1); 
        PVector normal = new PVector(-side.y, side.x).normalize(); 
        if (PVector.dot(ballPos, normal) - PVector.dot(v1, normal) > 0) { 
          float penetration = PVector.dot(ballPos, normal) - PVector.dot(v1, normal); 
          ballPos.sub(PVector.mult(normal, penetration)); 
          float vn = PVector.dot(ballVel, normal); 
          PVector reflection = PVector.mult(normal, 2 * vn); 
          ballVel.sub(reflection); 
          n++; 
          ballVel.setMag(calculateCurrentSpeed()); 
          updatePolygonVertices(); 
          targetPiApproximation = calculatePi(); 
          flash = 1.0; 
          bounceCooldown = bounceCooldownTime; 
          updateFormulaText(); 
          return;
        }
      }
    }
  }
  void updateTransitions() { 
    displayedPiApproximation = lerp((float)displayedPiApproximation, (float)targetPiApproximation, 0.2); 
    flash = lerp(flash, 0, 0.1);
  }
  void updatePolygonVertices() { 
    inscribedVertices = new PVector[n + 1]; 
    for (int i = 0; i < n; i++) { 
      float angle = rotationOffset + TWO_PI / n * i; 
      inscribedVertices[i] = new PVector(cos(angle) * radius, sin(angle) * radius);
    } 
    inscribedVertices[n] = inscribedVertices[0];
  }
  double calculatePi() { 
    double angle = Math.PI / n; 
    return (n * Math.sin(angle) + n * Math.tan(angle)) / 2.0;
  }
  void updateFormulaText() { 
    String pi = "\u03C0"; 
    String approx = "\u2248"; 
    formulaText = pi + " " + approx + " ( " + n + " x sin(" + pi + "/" + n + ") + " + n + " x tan(" + pi + "/" + n + ") ) / 2";
  }
  void drawPolygons() { 
    noFill(); 
    strokeJoin(ROUND); 
    color currentInscribedColor = lerpColor(inscribedColor, flashColor, flash); 
    color currentCircumscribedColor = lerpColor(circumscribedColor, flashColor, flash); 
    strokeWeight(2); 
    stroke(currentCircumscribedColor); 
    float r_circum = (float)(radius / cos(PI / n)); 
    beginShape(); 
    for (int i = 0; i < n; i++) { 
      float angle = rotationOffset + TWO_PI / n * i; 
      vertex(cos(angle) * r_circum, sin(angle) * r_circum);
    } 
    endShape(CLOSE); 
    stroke(currentInscribedColor); 
    strokeWeight(3); 
    beginShape(); 
    for (int i = 0; i < n; i++) { 
      vertex(inscribedVertices[i].x, inscribedVertices[i].y);
    } 
    endShape(CLOSE); 
    stroke(circleColor); 
    strokeWeight(1); 
    ellipse(0, 0, radius * 2, radius * 2);
  }
  void drawBall() { 
    if (gameState == 1) { 
      noStroke(); 
      fill(ballColor); 
      ellipse(ballPos.x, ballPos.y, ballRadius * 2, ballRadius * 2);
    }
  }
  void manageParticles() { 
    for (int i = particles.size() - 1; i >= 0; i--) { 
      Particle p = particles.get(i); 
      p.update(); 
      p.display(); 
      if (p.isDead()) { 
        particles.remove(i);
      }
    }
  }
  void drawUI() { 
    resetMatrix(); 
    textAlign(LEFT, TOP); 
    fill(textColor); 
    textSize(22); 
    text("Lados (n): " + n, 20, 20); 
    textSize(24); 
    text("Pi Aproximado: " + piFormatter.format(displayedPiApproximation), 20, 55); 
    fill(textColor, 180); 
    textSize(16); 
    text(formulaText, 20, 95); 
    textAlign(RIGHT, TOP); 
    fill(circleColor); 
    textSize(16); 
    text("Pi Real: 3,141592653...", width - 20, 20);
  }
  float pointLineDistance(PVector p, PVector a, PVector b) { 
    PVector ab = PVector.sub(b, a); 
    PVector ap = PVector.sub(p, a); 
    float t = PVector.dot(ap, ab) / ab.magSq(); 
    t = constrain(t, 0, 1); 
    PVector closestPoint = PVector.add(a, PVector.mult(ab, t)); 
    return p.dist(closestPoint);
  }
}


// #########################################################################
// # PROJETO 3: VISUALIZAÇÃO DE CONTINUIDADE (CÓDIGO INALTERADO)
// #########################################################################
class ContinuitySketch {
  // ... (código original inalterado) ...
  boolean isContinuous; 
  String title;
  float c, f_of_c, epsilon = 50, delta;
  float xMin = -5, xMax = 5, yMin = -3, yMax = 3;
  color bgColor, axisColor, continuousColor, epsilonColor, deltaColor, successColor, failureColor, textColor;
  ContinuitySketch() { 
    bgColor = color(10, 15, 25); 
    axisColor = color(100, 110, 120); 
    continuousColor = color(255); 
    epsilonColor = color(50, 200, 50, 150); 
    deltaColor = color(0, 200, 255, 150); 
    successColor = color(50, 255, 50); 
    failureColor = color(255, 80, 80); 
    textColor = color(230);
  }
  void start(boolean continuousMode) { 
    this.isContinuous = continuousMode; 
    title = isContinuous ? "Função Contínua" : "Função Descontínua (com Salto)"; 
    epsilon = 80;
  }
  void handleMousePress() { 
    if (mouseX > width - 220 && mouseX < width - 20 && mouseY > 20 && mouseY < 50) { 
      start(!isContinuous);
    }
  }
  void handleMouseWheel(MouseEvent event) { 
    epsilon -= event.getCount() * 5; 
    epsilon = constrain(epsilon, 2, 200);
  }
  float f_continuous(float x) { 
    return sin(x) + cos(x*0.5);
  }
  float f_discontinuous(float x) { 
    return (x >= 0) ? sin(x) + 0.5 : cos(x) - 1.5;
  }
  float f(float x) { 
    return isContinuous ? f_continuous(x) : f_discontinuous(x);
  }
  void update() { 
    c = map(mouseX, 0, width, xMin, xMax); 
    c = constrain(c, xMin, xMax); 
    f_of_c = f(c); 
    calculateDelta();
  }
  void calculateDelta() { 
    float f_upper = f_of_c + map(epsilon, 0, height/2, 0, yMax); 
    float f_lower = f_of_c - map(epsilon, 0, height/2, 0, yMax); 
    float delta_right = 0; 
    for (float x = c; x < xMax; x += 0.01) { 
      if (f(x) > f_upper || f(x) < f_lower) { 
        break;
      } 
      delta_right = x - c;
    } 
    float delta_left = 0; 
    for (float x = c; x > xMin; x -= 0.01) { 
      if (f(x) > f_upper || f(x) < f_lower) { 
        break;
      } 
      delta_left = c - x;
    } 
    delta = min(delta_left, delta_right);
  }
  void updateAndDraw() { 
    update(); 
    background(bgColor); 
    drawAxes(); 
    drawFunctionGraph(); 
    drawEpsilonDeltaBands(); 
    drawInteractionPoints(); 
    drawUI();
  }
  void drawAxes() { 
    stroke(axisColor); 
    strokeWeight(1); 
    line(0, height / 2, width, height / 2); 
    line(width / 2, 0, width / 2, height);
  }
  void drawFunctionGraph() { 
    noFill(); 
    stroke(continuousColor); 
    strokeWeight(3); 
    beginShape(); 
    for (float x_pixel = 0; x_pixel < width; x_pixel++) { 
      float x_coord = map(x_pixel, 0, width, xMin, xMax); 
      float y_coord = f(x_coord); 
      float y_pixel = map(y_coord, yMin, yMax, height, 0); 
      if (!isContinuous && abs(x_coord) < 0.05) { 
        endShape(); 
        beginShape();
      } 
      vertex(x_pixel, y_pixel);
    } 
    endShape();
  }
  void drawEpsilonDeltaBands() { 
    float cx_pixel = map(c, xMin, xMax, 0, width); 
    float cy_pixel = map(f_of_c, yMin, yMax, height, 0); 
    float delta_pixel = map(delta, 0, xMax, 0, width/2); 
    noStroke(); 
    fill(epsilonColor, 50); 
    rect(0, cy_pixel - epsilon, width, epsilon * 2); 
    stroke(epsilonColor); 
    strokeWeight(2); 
    line(0, cy_pixel - epsilon, width, cy_pixel - epsilon); 
    line(0, cy_pixel + epsilon, width, cy_pixel + epsilon); 
    noStroke(); 
    fill(deltaColor, 50); 
    rect(cx_pixel - delta_pixel, 0, delta_pixel * 2, height); 
    stroke(deltaColor); 
    strokeWeight(2); 
    line(cx_pixel - delta_pixel, 0, cx_pixel - delta_pixel, height); 
    line(cx_pixel + delta_pixel, 0, cx_pixel + delta_pixel, height);
  }
  void drawInteractionPoints() { 
    float cx_pixel = map(c, xMin, xMax, 0, width); 
    float cy_pixel = map(f_of_c, yMin, yMax, height, 0); 
    float delta_pixel = map(delta, 0, xMax, 0, width/2); 
    boolean success = true; 
    for (float x_p = cx_pixel - delta_pixel; x_p < cx_pixel + delta_pixel; x_p++) { 
      float y_p = map(f(map(x_p, 0, width, xMin, xMax)), yMin, yMax, height, 0); 
      if (y_p < cy_pixel - epsilon || y_p > cy_pixel + epsilon) { 
        success = false; 
        break;
      }
    } 
    strokeWeight(5); 
    if (success) { 
      stroke(successColor);
    } else { 
      stroke(failureColor);
    } 
    beginShape(); 
    for (float x_p = cx_pixel - delta_pixel; x_p <= cx_pixel + delta_pixel; x_p+=2) { 
      float x_c = map(x_p, 0, width, xMin, xMax); 
      float y_c = f(x_c); 
      float y_p = map(y_c, yMin, yMax, height, 0); 
      if (!isContinuous && abs(x_c) < 0.05) { 
        endShape(); 
        beginShape();
      } 
      vertex(x_p, y_p);
    } 
    endShape(); 
    noStroke(); 
    fill(255, 230, 0); 
    ellipse(cx_pixel, cy_pixel, 15, 15);
  }
  void drawUI() { 
    textAlign(LEFT, TOP); 
    fill(textColor); 
    textSize(28); 
    text(title, 20, 20); 
    textSize(18); 
    fill(textColor, 200); 
    text("Mova o mouse na horizontal para escolher o ponto 'c'.", 20, 60); 
    text("Use a roda do mouse para ajustar o desafio 'ε' (épsilon).", 20, 85); 
    textAlign(RIGHT, TOP); 
    textSize(16); 
    fill(0, 200, 255, 150); 
    text("[Alternar Função]", width - 20, 20); 
    float cx_pixel = map(c, xMin, xMax, 0, width); 
    float cy_pixel = map(f_of_c, yMin, yMax, height, 0); 
    float delta_pixel = map(delta, 0, xMax, 0, width/2); 
    fill(epsilonColor); 
    textAlign(LEFT, TOP); 
    text("ε", 10, cy_pixel - epsilon - 25); 
    text("ε", 10, cy_pixel + epsilon + 5); 
    fill(deltaColor); 
    textAlign(CENTER, TOP); 
    text("δ", cx_pixel - delta_pixel, 10); 
    text("δ", cx_pixel + delta_pixel, 10);
  }
}

// #########################################################################
// #                                                                       #
// #      PROJETO 4: VISUALIZAÇÃO DO ARQUEIRO (COM CORREÇÃO)               #
// #                                                                       #
// #########################################################################
class ArcherySketch {
  // Variáveis Globais para Posições e Ângulos
  PVector targetPos;
  PVector visualTargetCenter;
  PVector archerPivotPos;
  PVector currentArrowLaunchPoint;

  // Variáveis de Cálculo de Limite
  float distanceToTarget;
  float epsilon;
  float delta;
  float perfectAngleToTarget;
  float currentAimAngle;

  // Variáveis de Animação da Flecha
  PVector animatedArrowPos;
  float animatedArrowSpeed = 20;
  boolean arrowFlying = false;
  PVector arrowDirection;
  float arrowImpactY;
  float arrowFlightAngle;
  boolean lastShotWasAHit = false;

  // Imagens
  PImage archerImage;
  PImage realisticTargetImage;

  // Escalas
  float archerScale = 0.8;
  float targetScale = 0.9;

  // --- VALORES DE AJUSTE FINO ---
  PVector targetCenterOffset = new PVector(-12 * targetScale, -15 * targetScale - 40);
  PVector archerImageOffset = new PVector(0, -160 * archerScale);
  PVector arrowHandOffset = new PVector(135 * archerScale, -185 * archerScale + 10);

  // Construtor da classe
  ArcherySketch() {
    // Carrega as imagens. Lembre-se que elas devem estar na pasta 'data'
    try {
      archerImage = loadImage("archer.png");
      realisticTargetImage = loadImage("realistic_target.png");
    } 
    catch (Exception e) {
      println("ERRO CRÍTICO: Não foi possível carregar as imagens do Arqueiro ('archer.png', 'realistic_target.png') da pasta 'data'.");
      exit();
    }
    
    // BUGFIX: Inicializa os PVectors da animação para evitar NullPointerException
    animatedArrowPos = new PVector();
    arrowDirection = new PVector();
    
    imageMode(CENTER);

    targetPos = new PVector(width * 0.85, height / 2);
    visualTargetCenter = new PVector(targetPos.x + targetCenterOffset.x, targetPos.y + targetCenterOffset.y);
    
    archerPivotPos = new PVector(width * 0.15, height / 2 + 150 * archerScale);

    epsilon = 101.0;
    
    resetArrow();
  }

  void updateAndDraw() {
    background(20, 25, 30);

    // --- ATUALIZAÇÃO DINÂMICA (a cada frame) ---
    float directAngleToMouse = atan2(mouseY - archerPivotPos.y, mouseX - archerPivotPos.x);
    float angleLimit = PI/4;
    currentAimAngle = constrain(directAngleToMouse, -angleLimit, angleLimit);

    currentArrowLaunchPoint = new PVector(
      archerPivotPos.x + arrowHandOffset.x * cos(currentAimAngle) - arrowHandOffset.y * sin(currentAimAngle), 
      archerPivotPos.y + arrowHandOffset.x * sin(currentAimAngle) + arrowHandOffset.y * cos(currentAimAngle)
      );

    distanceToTarget = dist(currentArrowLaunchPoint.x, currentArrowLaunchPoint.y, visualTargetCenter.x, visualTargetCenter.y);
    perfectAngleToTarget = atan2(visualTargetCenter.y - currentArrowLaunchPoint.y, visualTargetCenter.x - currentArrowLaunchPoint.x);

    epsilon = constrain(epsilon, 1, 150);
    if (epsilon < distanceToTarget) {
      delta = asin(epsilon / distanceToTarget);
    } else {
      delta = PI;
    }

    boolean displayHitStatus;
    if (arrowFlying) {
      displayHitStatus = lastShotWasAHit;
    } else {
      displayHitStatus = (abs(currentAimAngle - perfectAngleToTarget) <= delta);
    }

    // Lógica de Voo da Flecha
    if (arrowFlying) {
      animatedArrowPos.add(arrowDirection);
      if (animatedArrowPos.x > visualTargetCenter.x + epsilon * 2 || animatedArrowPos.x < 0 || animatedArrowPos.y > height || animatedArrowPos.y < 0) {
        arrowFlying = false;
      }
    } else {
      animatedArrowPos = currentArrowLaunchPoint.copy();
      arrowFlightAngle = currentAimAngle;
    }

    // --- DESENHO DOS ELEMENTOS ---
    // 1. Cone do Acerto
    float coneLength = distanceToTarget * 1.1;
    float x1 = currentArrowLaunchPoint.x, y1 = currentArrowLaunchPoint.y;
    float x2 = currentArrowLaunchPoint.x + coneLength * cos(perfectAngleToTarget - delta);
    float y2 = currentArrowLaunchPoint.y + coneLength * sin(perfectAngleToTarget - delta);
    float x3 = currentArrowLaunchPoint.x + coneLength * cos(perfectAngleToTarget + delta);
    float y3 = currentArrowLaunchPoint.y + coneLength * sin(perfectAngleToTarget + delta);
    noStroke(); 
    fill(0, 150, 255, 30); 
    beginShape(); 
    vertex(x1, y1); 
    vertex(x2, y2); 
    vertex(x3, y3); 
    endShape(CLOSE);
    strokeWeight(2); 
    stroke(0, 150, 255, 70); 
    line(x1, y1, x2, y2); 
    line(x1, y1, x3, y3);

    // 2. Alvo e Círculo Epsilon
    tint(255, 255);
    image(realisticTargetImage, targetPos.x, targetPos.y, realisticTargetImage.width * targetScale, realisticTargetImage.height * targetScale);
    noStroke();
    if (displayHitStatus) fill(100, 255, 100, 100); 
    else fill(255, 100, 100, 100);
    ellipse(visualTargetCenter.x, visualTargetCenter.y, epsilon * 2, epsilon * 2);

    // 3. Flecha Animada
    if (arrowFlying || !arrowFlying) {
      strokeWeight(3); 
      stroke(100, 50, 20);
      float arrowLengthVisual = 50;
      float endX = animatedArrowPos.x + cos(arrowFlightAngle) * arrowLengthVisual;
      float endY = animatedArrowPos.y + sin(arrowFlightAngle) * arrowLengthVisual;
      line(animatedArrowPos.x, animatedArrowPos.y, endX, endY);
      pushMatrix(); 
      translate(endX, endY); 
      rotate(arrowFlightAngle); 
      fill(150); 
      noStroke(); 
      triangle(0, 0, -15, -5, -15, 5); 
      popMatrix();
    }

    // 4. Arqueiro Rotativo
    pushMatrix();
    translate(archerPivotPos.x, archerPivotPos.y);
    rotate(currentAimAngle);
    tint(255, 255);
    image(archerImage, archerImageOffset.x, archerImageOffset.y, archerImage.width * archerScale, archerImage.height * archerScale);
    popMatrix();

    // 5. Textos e Controles
    fill(255); 
    textSize(20); 
    textAlign(LEFT, TOP);
    text(String.format("Raio do Alvo (ε): %.2f px", epsilon), 20, 20);
    text(String.format("Variação Angular (δ): ±%.2f°", degrees(delta)), 20, 50);
    textAlign(CENTER, TOP); 
    textSize(28);
    if (displayHitStatus) { 
      fill(100, 255, 100); 
      text("ACERTOU!", width/2, 20);
    } else { 
      fill(255, 100, 100); 
      text("ERROU!", width/2, 20);
    }
    textSize(14); 
    fill(200); 
    textAlign(RIGHT, BOTTOM);
    text("Clique para Lançar!", width - 20, height - 60);
    text("Mova o Mouse para Mirar", width - 20, height - 20);
    text("Controle o Raio (Rodinha do Mouse)", width - 20, height - 40);
  }

  // Métodos para lidar com eventos
  void handleMousePress() {
    if (!arrowFlying) {
      launchArrow();
    }
  }

  void handleMouseWheel(MouseEvent event) {
    epsilon -= event.getCount() * 5;
  }
  
  // Métodos auxiliares
  void launchArrow() {
    arrowFlying = true;
    animatedArrowPos = currentArrowLaunchPoint.copy();
    arrowFlightAngle = currentAimAngle;

    arrowDirection = new PVector(cos(arrowFlightAngle) * animatedArrowSpeed, sin(arrowFlightAngle) * animatedArrowSpeed);

    float dx = visualTargetCenter.x - currentArrowLaunchPoint.x;
    float dy = tan(arrowFlightAngle) * dx;
    arrowImpactY = currentArrowLaunchPoint.y + dy;

    lastShotWasAHit = (abs(arrowImpactY - visualTargetCenter.y) <= epsilon);
  }

  void resetArrow() {
    arrowFlying = false;
  }
}
