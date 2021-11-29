#! /usr/bin/env bash
# -*- coding: utf-8 -*-

LIB="$(dirname "$(readlink -f "$0")")/lib"

# shellcheck source=tests_base.sh
. tests_base.sh

# called once
oneTimeSetUp() {
    sudo cp /etc/crowdsec/config.yaml ./config.yaml.backup
}

# called once
oneTimeTearDown() {
    : # noop
}

# called before each test
setUp() {
    : # noop
}

# called after each test
tearDown() {
    : # noop
}


test_systemd() {
    ## status / start / stop
    # service should be up
    pgrep -x crowdsec >/dev/null || fail "crowdsec process should be running"
    ${SYSTEMCTL} status crowdsec >/dev/null || fail "systemctl status crowdsec failed"

    ##shut it down
    ${SYSTEMCTL} stop crowdsec >/dev/null || fail "failed to stop service"
    ${SYSTEMCTL} status crowdsec >/dev/null && fail "crowdsec should be down"
    pgrep -x crowdsec >/dev/null && fail "crowdsec process shouldn't be running"

    ##start it again
    ${SYSTEMCTL} start crowdsec >/dev/null || fail "failed to startservice"
    ${SYSTEMCTL} status crowdsec  >/dev/null || fail "crowdsec should be up"
    wait_for_service "crowdsec process should be running"

    ##restart it
    ${SYSTEMCTL} restart crowdsec >/dev/null || fail "failed to restart service"
    ${SYSTEMCTL} status crowdsec >/dev/null || fail "crowdsec should be up"
    wait_for_service "crowdsec process should be running"
}

test_Agent_LAPI_CAPI() {
    ## version
    ${CSCLI} version 2>/dev/null || fail "cannot run cscli version"

    ## alerts
    # alerts list at startup should just return one entry : community pull
    sleep 5
    assertEquals \
	    "expected at least one entry from cscli alerts list" \
	    "$(${CSCLI} alerts list -ojson | ${JQ} '. | length >= 1')" \
	    "true"

    ## capi
    ${CSCLI} capi status >/dev/null 2>&1 || fail "capi status should be ok"
    ## config
    ${CSCLI} config show >/dev/null || fail "failed to show config"
    ${CSCLI} config backup ./test >/dev/null 2>&1 || fail "failed to backup config"
    sudo rm -rf ./test
    ## lapi
    ${CSCLI} lapi status 2>/dev/null >/dev/null || fail "lapi status failed"
    ## metrics
    ${CSCLI} metrics >/dev/null 2>&1 || fail "failed to get metrics"

    ${SYSTEMCTL} stop crowdsec >/dev/null || fail "crowdsec should be down"
}



testAgent_NOAPI() {
    :
#    ## test with -no-api flag
#    cp ${SYSTEMD_SERVICE_FILE} /tmp/crowdsec.service-orig
#    sed '/^ExecStart/ s/$/ -no-api/' ${SYSTEMD_SERVICE_FILE} > /tmp/crowdsec.service
#    sudo mv /tmp/crowdsec.service /etc/systemd/system/crowdsec.service
#
#    ${SYSTEMCTL} daemon-reload
#    ${SYSTEMCTL} start crowdsec
#    sleep 1
#    pgrep -x crowdsec && fail "crowdsec shouldn't run without LAPI (in flag)"
#    ${SYSTEMCTL} stop crowdsec
#
#    sudo cp /tmp/crowdsec.service-orig /etc/systemd/system/crowdsec.service
#
#    ${SYSTEMCTL} daemon-reload
#
#    # test with no api server in configuration file
#    sudo cp ./config/config_no_lapi.yaml /etc/crowdsec/config.yaml
#    ${SYSTEMCTL} start crowdsec
#    sleep 1
#    pgrep -x crowdsec && fail "crowdsec agent should not run without lapi (in configuration file)"

#    ##### cscli test ####
#    ## capi
#    ${CSCLI} -c ./config/config_no_lapi.yaml capi status && fail "capi status shouldn't be ok"
#    ## config
#    ${CSCLI_BIN} -c ./config/config_no_lapi.yaml config show || fail "failed to show config"
#    ${CSCLI} -c ./config/config_no_lapi.yaml config backup ./test || fail "failed to backup config"
#    sudo rm -rf ./test
#    ## lapi
#    ${CSCLI} -c ./config/config_no_lapi.yaml lapi status && fail "lapi status should not be ok" ## if lapi status success, it means that the test fail
#    ## metrics
#    ${CSCLI_BIN} -c ./config/config_no_lapi.yaml metrics

#    ${SYSTEMCTL} stop crowdsec
#    sudo cp ./config/config.yaml /etc/crowdsec/config.yaml
}



testNoAgent_LAPI_CAPI() {
    :
    ## test with -no-cs flag
    #sed '/^ExecStart/ s/$/ -no-cs/' /etc/systemd/system/crowdsec.service > /tmp/crowdsec.service
    #sudo mv /tmp/crowdsec.service /etc/systemd/system/crowdsec.service 
    #
    #
    #${SYSTEMCTL} daemon-reload
    #${SYSTEMCTL} start crowdsec 
    #wait_for_service "crowdsec LAPI should run without agent (in flag)"
    #${SYSTEMCTL} stop crowdsec
    #
    #sed '/^ExecStart/s/-no-cs//g' ${SYSTEMD_SERVICE_FILE} > /tmp/crowdsec.service
    #sudo mv /tmp/crowdsec.service /etc/systemd/system/crowdsec.service
    #
    #${SYSTEMCTL} daemon-reload
    #
    ## test with no crowdsec agent in configuration file
    #sudo cp ./config/config_no_agent.yaml /etc/crowdsec/config.yaml
    #${SYSTEMCTL} start crowdsec
    #wait_for_service "crowdsec LAPI should run without agent (in configuration file)"
    #
    #
    ### capi
    #${CSCLI} -c ./config/config_no_agent.yaml capi status || fail "capi status should be ok"
    ### config
    #${CSCLI_BIN} -c ./config/config_no_agent.yaml config show || fail "failed to show config"
    #${CSCLI} -c ./config/config_no_agent.yaml config backup ./test || fail "failed to backup config"
    #sudo rm -rf ./test
    ### lapi
    #${CSCLI} -c ./config/config_no_agent.yaml lapi status || fail "lapi status failed"
    ### metrics
    #${CSCLI_BIN} -c ./config/config_no_agent.yaml metrics || fail "failed to get metrics"
    #
    #${SYSTEMCTL} stop crowdsec
    #sudo cp ./config/config.yaml /etc/crowdsec/config.yaml
}



testAgent_LAPI() {
    :
    ## test with no online client in configuration file
    #sudo cp ./config/config_no_capi.yaml /etc/crowdsec/config.yaml
    #${SYSTEMCTL} start crowdsec
    #wait_for_service "crowdsec LAPI should run without CAPI (in configuration file)"
    #
    ### capi
    #${CSCLI} -c ./config/config_no_capi.yaml capi status && fail "capi status should not be ok" ## if capi status success, it means that the test fail
    ### config
    #${CSCLI_BIN} -c ./config/config_no_capi.yaml config show || fail "failed to show config"
    #${CSCLI} -c ./config/config_no_capi.yaml config backup ./test || fail "failed to backup config"
    #sudo rm -rf ./test
    ### lapi
    #${CSCLI} -c ./config/config_no_capi.yaml lapi status || fail "lapi status failed"
    ### metrics
    #${CSCLI_BIN} -c ./config/config_no_capi.yaml metrics || fail "failed to get metrics"
    #
    #sudo mv /tmp/crowdsec.service-orig /etc/systemd/system/crowdsec.service
    #
    #sudo cp ./config.yaml.backup /etc/crowdsec/config.yaml
    #
    #${SYSTEMCTL} daemon-reload
    #${SYSTEMCTL} restart crowdsec
    #wait_for_service "crowdsec should be restarted)"
}




# shellcheck source=lib/shunit2
. "$LIB/shunit2"
