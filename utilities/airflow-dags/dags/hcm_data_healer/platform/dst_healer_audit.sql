CREATE TABLE IF NOT EXISTS dst_healer_run (
    dag_run_id        VARCHAR(250) NOT NULL,
    tenant_id         VARCHAR(64)  NOT NULL,
    campaign_name     VARCHAR(256),
    window_start      VARCHAR(10)  NOT NULL,
    window_end        VARCHAR(10)  NOT NULL,
    error_tracer      BOOLEAN,
    status            VARCHAR(32)  NOT NULL,
    failed_step       VARCHAR(32),
    reason            VARCHAR(500),
    found_total       INTEGER,
    created           INTEGER,
    reindexed         INTEGER,
    already_present   INTEGER,
    failed            INTEGER,
    unrecoverable     INTEGER,
    started_at_ms     BIGINT       NOT NULL,
    finished_at_ms    BIGINT,
    PRIMARY KEY (dag_run_id, tenant_id, window_start)
);
CREATE INDEX IF NOT EXISTS idx_dst_healer_run_tenant ON dst_healer_run (tenant_id, window_start);
CREATE INDEX IF NOT EXISTS idx_dst_healer_run_status ON dst_healer_run (status, started_at_ms DESC);

CREATE TABLE IF NOT EXISTS dst_healer_record (
    record_id            VARCHAR(64)  PRIMARY KEY,
    dag_run_id           VARCHAR(250) NOT NULL,
    tenant_id            VARCHAR(64)  NOT NULL,
    window_start         VARCHAR(10)  NOT NULL,
    entity               VARCHAR(64)  NOT NULL,
    client_reference_id  VARCHAR(128) NOT NULL,
    issue                VARCHAR(48)  NOT NULL,
    found_in             VARCHAR(16)  NOT NULL,
    action               VARCHAR(8)   NOT NULL,
    outcome              VARCHAR(32)  NOT NULL,
    outcome_reason       VARCHAR(1000),
    payload              JSONB,
    source_error_code    VARCHAR(128),
    source_error_message VARCHAR(1000),
    source_error_time    VARCHAR(40),
    source_api_url       VARCHAR(300),
    source_doc_id        VARCHAR(128),
    api_status           VARCHAR(8),
    api_response         VARCHAR(2000),
    recorded_at_ms       BIGINT       NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_dst_healer_record_run   ON dst_healer_record (dag_run_id, tenant_id, window_start);
CREATE INDEX IF NOT EXISTS idx_dst_healer_record_crid  ON dst_healer_record (tenant_id, client_reference_id);
CREATE INDEX IF NOT EXISTS idx_dst_healer_record_issue ON dst_healer_record (tenant_id, issue, outcome);
