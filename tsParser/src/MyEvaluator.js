import { BasicEvaluator } from "conductor/dist/conductor/runner";
const eval2 = eval;
export class MyEvaluator extends BasicEvaluator {
    someEvaluatorState;
    async evaluateChunk(chunk) {
        this.someEvaluatorState++;
        eval2(chunk);
        this.conductor.sendOutput(`Chunk ${this.someEvaluatorState} evaluated!`);
    }
    constructor(conductor) {
        super(conductor);
        this.someEvaluatorState = 0;
    }
}
//# sourceMappingURL=MyEvaluator.js.map