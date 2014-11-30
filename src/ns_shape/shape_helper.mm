//
//  shape_helper.mm
//

#include "shape_helper.h"
#include "Environment.h"
#include "square.h"
#include "triangle.h"
#include "hexagon.h"
#include "equilateral.h"
#include "circle.h"
#include "Timekeeper.h"


namespace cellophane {
  
namespace ns_shape {

  
// aliases
using EG = lib_maximplus::Envelope;
using Env = cellophane::Environment;
  

ShapeArgs createArgs(const ofPoint& center, const ofColor color, bool filling) {
  ShapeArgs args = {
    .center = center, .color = color, .filling = filling
  };
  return args;
}

const ShapeArgs createUserArgs(const ofPoint& center, const ofColor color,
                               bool filling, int duration, BaseCA* ca,
                               bool touch_moved) {
  ShapeArgs args = createArgs(center, color, filling);
  args.type = KG::kSquareShape;
  
  const float ratio = ca->getLiveRatio();
  const int angle_offset = (ratio < 0.5f) ? 0 : 1;
  args.angle = ns_shape::getRotatedAngle(args.type, 0.0f, angle_offset);
  args.size = convertToShapeSize(duration, touch_moved);
  args.width = getAdjustedWidth(args.type, args.angle, args.size);
  args.height = getAdjustedHeight(args.type, args.angle, args.size);
  
  return args;
}
  
const ShapeArgs createUserTouchDownArgs(const ofPoint& center,
                                        const ofColor color, bool filling,
                                        int duration, BaseCA* ca) {
  return createUserArgs(center, color, filling, duration, ca, false);
}

const ShapeArgs createUserTouchMovedArgs(const ofPoint& center,
                                         const ofColor color, bool filling,
                                         int duration, BaseCA* ca) {
  return createUserArgs(center, color, filling, duration, ca, true);
}

const ShapeArgs createPlayerArgs(const ofPoint& center, const ofColor color,
                                 bool filling, int duration, BaseCA* ca) {
  ShapeArgs args = createArgs(center, color, filling);
  args.type = KG::kSquareShape;

  const float ratio = ca->getLiveRatio();
  const int angle_offset = (ratio < 0.5f) ? 0 : 1;
  const int rotation = static_cast<int>(roundf(ratio * 4)) + angle_offset;
  args.angle = ns_shape::getRotatedAngle(args.type, 0.0f, rotation);
  args.size = convertToShapeSize(duration, false);
  args.width = getAdjustedWidth(args.type, args.angle, args.size);
  args.height = getAdjustedHeight(args.type, args.angle, args.size);
  
  return args;
}
  
int convertToShapeSize(int duration, bool touch_moved) {
  if (touch_moved) return Env::getInstance().getShapeSize(0);
  
  const int step =
      static_cast<int>(roundf(static_cast<float>(duration) /
                              Timekeeper::getInstance().getStepTime()));
  const int size_idx = (step < 6) ? 1 : 2;
  return Env::getInstance().getShapeSize(size_idx);
}
 
float getRotatedAngle(KG::ShapeTypes type, float current_angle, int rotation) {
  float angle_step = getAngleStep(type);
  if (angle_step > 0.0f) {
    int step_size = static_cast<int>(360 / angle_step);
    float degree = (rotation >= 0) ? angle_step * (rotation % step_size) :
        -angle_step * (-rotation % step_size);
    return current_angle + degree;
  } else {
    return 0.0f;
  }
}

float getRotatedAngle(KG::ShapeTypes type, float current_angle) {
  int rotation = static_cast<int>(ofRandom(1, 3));
  if (ofRandom(1.0f) < 0.5f) rotation *= -1;
  return getRotatedAngle(type, current_angle, rotation);
}

float getAdjustedWidth(KG::ShapeTypes type, float angle, float size) {
  float width = 0.0f;
  if (type == KG::kSquareShape) {
    width = square::getAdjustedWidth(angle, size);
  } else if (type == KG::kTriangleShape) {
    width = triangle::getAdjustedWidth(angle, size);
  } else if (type == KG::kHexagonShape) {
    width = hexagon::getAdjustedWidth(angle, size);
  } else if (type == KG::kEquilateralShape) {
    width = equilateral::getAdjustedWidth(angle, size);
  } else if (type == KG::kCircleShape) {
    width = circle::getAdjustedWidth(angle, size);
  }
  return width;
}

float getAdjustedHeight(KG::ShapeTypes type, float angle, float size) {
  float height = 0.0f;
  if (type == KG::kSquareShape) {
    height = square::getAdjustedHeight(angle, size);
  } else if (type == KG::kTriangleShape) {
    height = triangle::getAdjustedHeight(angle, size);
  } else if (type == KG::kHexagonShape) {
    height = hexagon::getAdjustedHeight(angle, size);
  } else if (type == KG::kEquilateralShape) {
    height = equilateral::getAdjustedHeight(angle, size);
  } else if (type == KG::kCircleShape) {
    height = circle::getAdjustedHeight(angle, size);
  }
  return height;
}

int getNumberOfVertices(KG::ShapeTypes type) {
  int number_of_vertices = 0;
  if (type == KG::kSquareShape) {
    number_of_vertices = square::kNumberOfVertices;
  } else if (type == KG::kTriangleShape) {
    number_of_vertices = triangle::kNumberOfVertices;
  } else if (type == KG::kHexagonShape) {
    number_of_vertices = hexagon::kNumberOfVertices;
  } else if (type == KG::kEquilateralShape) {
    number_of_vertices = equilateral::kNumberOfVertices;
  } else if (type == KG::kCircleShape) {
    number_of_vertices = circle::kNumberOfVertices;
  }
  return number_of_vertices;
}

const ofVec3f getVertexVector(KG::ShapeTypes type, float angle,
                             float size, int vertex_number) {
  ofVec3f vec(0, 0, 0);
  if (type == KG::kSquareShape) {
    vec = square::getVertexVector(angle, size, vertex_number);
  } else if (type == KG::kTriangleShape) {
    vec = triangle::getVertexVector(angle, size, vertex_number);
  } else if (type == KG::kHexagonShape) {
    vec = hexagon::getVertexVector(angle, size, vertex_number);
  } else if (type == KG::kEquilateralShape) {
    vec = equilateral::getVertexVector(angle, size, vertex_number);
  } else if (type == KG::kCircleShape) {
    vec = circle::getVertexVector(angle, size, vertex_number);
  }
  return vec;
}

void draw(KG::ShapeTypes type, float width, float height) {
  if (type == KG::kSquareShape) {
    square::draw(width, height);
  } else if (type == KG::kTriangleShape) {
    triangle::draw(width, height);
  } else if (type == KG::kEquilateralShape) {
    equilateral::draw(width, height);
  } else if (type == KG::kHexagonShape) {
    hexagon::draw(width, height);
  } else if (type == KG::kCircleShape) {
    circle::draw(width, height);
  }
}

float getAngleStep(KG::ShapeTypes type) {
  float angle_step = 0.0f;
  if (type == KG::kSquareShape) {
    angle_step = square::kAngleStep;
  } else if (type == KG::kTriangleShape) {
    angle_step = triangle::kAngleStep;
  } else if (type == KG::kHexagonShape) {
    angle_step = hexagon::kAngleStep;
  } else if (type == KG::kEquilateralShape) {
    angle_step = equilateral::kAngleStep;
  } else if (type == KG::kCircleShape) {
    angle_step = circle::kAngleStep;
  }
  return angle_step;
}

  
}  // namespace ns_shape

}  // namespace cellophane
