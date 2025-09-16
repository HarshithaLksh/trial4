.PHONY: test package clean
test:
	@chmod +x app/greet.sh tests/test_greet.sh
	@./tests/test_greet.sh
package: test
	@mkdir -p dist
	@tar -czf dist/hello-ci-mini-$(shell date +%Y%m%d%H%M%S).tar.gz app README.md
clean:
	@rm -rf dist
