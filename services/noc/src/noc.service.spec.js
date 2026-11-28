"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var noc_service_1 = require("./noc.service");
describe('NocService', function () {
    var service;
    beforeEach(function () {
        service = new noc_service_1.NocService();
    });
    it('deve retornar o status online do serviço NOC', function () {
        expect(service.getStatus()).toEqual({
            status: 'online',
            service: 'NOC',
        });
    });
});
//# sourceMappingURL=noc.service.spec.js.map