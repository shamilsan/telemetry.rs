.PHONY: all backend checkout clean frontend install serve serve-core serve-frontend serve-shard

all: backend frontend

backend: checkout
	@echo ──────────── Build backend ────────────────────
	@cd substrate-telemetry/backend && cargo b -r
	@mkdir -p artifact
	@cp -fv substrate-telemetry/backend/target/release/telemetry_core artifact/
	@cp -fv substrate-telemetry/backend/target/release/telemetry_shard artifact/

checkout:
	@echo ──────────── Repo checkout ────────────────────
	@if [ ! -d "substrate-telemetry" ]; then \
		git clone "https://github.com/paritytech/substrate-telemetry.git"; \
	else \
		cd substrate-telemetry; \
		git reset --hard && git pull; \
	fi
	@cp -rvf frontend/* substrate-telemetry/frontend
	@find substrate-telemetry/frontend/src -name "*.css" -type f -exec sed -ie 's/#e6007a/#00a87a/g' {} \;

clean:
	@echo ──────────── Clean up ─────────────────────────
	rm -rfv artifact substrate-telemetry

frontend: checkout
	@echo ──────────── Build frontend ───────────────────
	@cd substrate-telemetry/frontend && yarn && yarn build
	@mkdir -p artifact
	@cd substrate-telemetry/frontend \
		&& rm -rf html \
		&& mv -f build html \
		&& tar -cvJf ../../artifact/frontend-html.tar.xz html

install: all
	@ansible-playbook ansible/install.yml -i telemetry.rs, -u ubuntu --key-file .ansible_key

serve: serve-core serve-shard serve-frontend

serve-core: backend
	@substrate-telemetry/backend/target/release/telemetry_core

serve-frontend:
	@cd substrate-telemetry/frontend && yarn && yarn start

serve-shard: backend
	@substrate-telemetry/backend/target/release/telemetry_shard
