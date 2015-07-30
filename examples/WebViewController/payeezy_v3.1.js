var Payeezy = function() {
    function e(e) {
        var t = {
        visa: /^4[0-9]{12}(?:[0-9]{3})?$/,
        mastercard: /^5[1-5][0-9]{14}$/,
        amex: /^3[47][0-9]{13}$/,
        diners: /^3(?:0[0-5]|[68][0-9])[0-9]{11}$/,
        discover: /^6(?:011|5[0-9]{2})[0-9]{12}$/,
        jcb: /^(?:2131|1800|35\d{3})\d{11}$/
        };
        for (var n in t) {
            if (t[n].test(e)) {
                return n
            }
        }
    }
    
    function t() {
        var e = [];
        var t = document.getElementsByTagName("input");
        var n = document.getElementsByTagName("select");
        for (i = 0; i < t.length; i++) {
            var r = t[i];
            var s = r.getAttribute("payeezy-data");
            if (s) {
                e[s] = r.value
            }
        }
        for (i = 0; i < n.length; i++) {
            var r = n[i];
            var s = r.getAttribute("payeezy-data");
            if (s) {
                e[s] = r.value
            }
        }
        return e
    }
    return {
    createToken: function(e) {
        var n = "api-cert.payeezy.com";
        this["clientCallback"] = e;
        var r = t();
        var i = 0;
        var s = {};
        var o = 0;
        var u = [];
        if (!this.apikey) {
            i = 400;
            u[o] = {
            description: "Please set the API Key"
            };
            o++
        }
        if (!this.js_security_key) {
            i = 400;
            u[o] = {
            description: "Please set the js_security_key"
            }
        }
        if (u.length > 0) {
            s["error"] = {
            messages: u
            };
            e(i, s);
            return false
        }
        var a = "https://" + n + "/v1/securitytokens?apikey=" + this.apikey + "&js_security_key=" + this.js_security_key + "&callback=Payeezy.callback&type=FDToken&credit_card.type=" + r["card_type"] + "&credit_card.cardholder_name=" + r["cardholder_name"] + "&credit_card.card_number=" + r["cc_number"] + "&credit_card.exp_date=" + r["exp_month"] + r["exp_year"] + "&credit_card.cvv=" + r["cvv_code"];
        var f = document.createElement("script");
        f.src = a;
        document.getElementsByTagName("head")[0].appendChild(f)
    },
    setApiKey: function(e) {
        this["apikey"] = e
    },
    setJs_Security_Key: function(e) {
        this["js_security_key"] = e
    },
    callback: function(e) {
        this["clientCallback"](e.status, e.results)
    }
    }
}();
