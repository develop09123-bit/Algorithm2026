// Interactive Infix to Postfix Calculator in Processing

String userInput = "3 + 5 * ( 2 - 8 )"; // 초기값 및 사용자 입력 저장용
ArrayList<String> postfixList = new ArrayList<String>();
float finalResult = 0;
boolean isCalculated = false;
String errorMessage = "";

void setup() {
  size(700, 450);
  background(40);
  
  // 초기식 계산
  calculate();
}

void draw() {
  background(40);
  
  // 타이틀 및 안내
  fill(200);
  textSize(14);
  text("Enter 키를 누르면 계산됩니다. 각 토큰(숫자, 연산자, 괄호)은 띄어쓰기로 구분해 주세요.", 50, 40);
  text("예시: 12 + 5 * ( 3 - 1 )", 50, 65);
  
  // 1. 사용자 입력창 영역
  fill(55);
  stroke(100);
  rect(50, 90, 600, 45, 5);
  
  fill(255);
  textSize(20);
  // 커서 깜빡임 효과 (간단 구현)
  String cursor = (frameCount / 30 % 2 == 0) ? "|" : "";
  text(userInput + cursor, 65, 120);
  
  // 2. 결과 출력 영역
  if (isCalculated) {
    if (!errorMessage.equals("")) {
      fill(255, 100, 100);
      textSize(18);
      text("Error: " + errorMessage, 50, 200);
    } else {
      // 후위 표기식 출력
      fill(180);
      textSize(16);
      String postStr = "";
      for (String s : postfixList) {
        postStr += s + " ";
      }
      text("Postfix Expression:", 50, 190);
      
      fill(255);
      textSize(22);
      text(postStr, 50, 225);
      
      // 최종 연산 결과 출력
      fill(100, 255, 100);
      textSize(18);
      text("Result:", 50, 290);
      
      textSize(36);
      text(finalResult, 50, 340);
    }
  }
}

// 키보드 입력 이벤트 처리
void keyPressed() {
  if (key == ENTER || key == RETURN) {
    calculate();
  } else if (key == BACKSPACE) {
    if (userInput.length() > 0) {
      userInput = userInput.substring(0, userInput.length() - 1);
    }
  } else if (key != CODED && key != ESC) {
    // 일반 문자 입력 (숫자, 연산자, 괄호, 공백 등)
    userInput += key;
  }
}

// 계산 실행 함수
void calculate() {
  errorMessage = "";
  try {
    postfixList = infixToPostfix(userInput);
    finalResult = evaluatePostfix(postfixList);
    isCalculated = true;
  } catch (Exception e) {
    errorMessage = "올바르지 않은 수식 형식이거나 연산 오류가 발생했습니다.";
    isCalculated = true;
  }
}

// 연산자 우선순위 반환
int getPrecedence(String op) {
  if (op.equals("+") || op.equals("-")) return 1;
  if (op.equals("*") || op.equals("/")) return 2;
  return 0;
}

// Infix -> Postfix 변환 함수
ArrayList<String> infixToPostfix(String infix) {
  ArrayList<String> output = new ArrayList<String>();
  ArrayList<String> stack = new ArrayList<String>();
  
  String[] tokens = splitTokens(infix, " ");
  
  for (String token : tokens) {
    if (isNumeric(token)) {
      output.add(token);
    } 
    else if (token.equals("(")) {
      stack.add(token);
    } 
    else if (token.equals(")")) {
      while (!stack.isEmpty() && !stack.get(stack.size() - 1).equals("(")) {
        output.add(stack.remove(stack.size() - 1));
      }
      if (!stack.isEmpty() && stack.get(stack.size() - 1).equals("(")) {
        stack.remove(stack.size() - 1);
      } else {
        errorMessage = "괄호 쌍이 맞지 않습니다.";
      }
    } 
    else if (token.equals("+") || token.equals("-") || token.equals("*") || token.equals("/")) {
      while (!stack.isEmpty() && getPrecedence(stack.get(stack.size() - 1)) >= getPrecedence(token)) {
        output.add(stack.remove(stack.size() - 1));
      }
      stack.add(token);
    } else {
      errorMessage = "잘못된 토큰이 포함되어 있습니다: " + token;
    }
  }
  
  while (!stack.isEmpty()) {
    String top = stack.remove(stack.size() - 1);
    if (top.equals("(")) errorMessage = "괄호 쌍이 맞지 않습니다.";
    output.add(top);
  }
  
  return output;
}

// Postfix 계산 함수
float evaluatePostfix(ArrayList<String> postfix) {
  ArrayList<Float> stack = new ArrayList<Float>();
  
  for (String token : postfix) {
    if (isNumeric(token)) {
      stack.add(float(token));
    } else {
      if (stack.size() < 2) {
        errorMessage = "수식이 완전하지 않습니다.";
        return 0;
      }
      float b = stack.remove(stack.size() - 1);
      float a = stack.remove(stack.size() - 1);
      float res = 0;
      
      if (token.equals("+")) res = a + b;
      else if (token.equals("-")) res = a - b;
      else if (token.equals("*")) res = a * b;
      else if (token.equals("/")) {
        if (b == 0) {
          errorMessage = "0으로 나눌 수 없습니다.";
          return 0;
        }
        res = a / b;
      }
      stack.add(res);
    }
  }
  
  if (stack.size() != 1) {
    errorMessage = "수식에 연산자나 피연산자가 부족합니다.";
    return 0;
  }
  
  return stack.get(0);
}

// 숫자 판별 유틸 함수
boolean isNumeric(String str) {
  try {
    Float.parseFloat(str);
    return true;
  } catch (NumberFormatException e) {
    return false;
  }
}
