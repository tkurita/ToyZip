install: clean
	xcodebuild -workspace ToyZip.xcworkspace -scheme ToyZip install DSTROOT=${HOME}

clean:
	xcodebuild -workspace ToyZip.xcworkspace -scheme ToyZip clean
