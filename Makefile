CXX = clang++
CXXFLAGS = $(shell llvm-config --cxxflags) -fno-rtti
LDFLAGS = $(shell llvm-config --ldflags)
LIBS = $(shell llvm-config --libs core irreader --system-libs)

TARGET = output
SRC = main.cpp

all: $(TARGET)

$(TARGET): $(SRC)
	$(CXX) $(CXXFLAGS) $(LDFLAGS) $< -o $@ $(LIBS)

clean:
	rm -f $(TARGET)
