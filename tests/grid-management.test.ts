import { describe, it, expect, beforeEach } from "vitest"

// Mock storage for grid load
const gridLoad = new Map<string, { currentLoad: number; capacity: number }>()
let contractOwner = "owner"

// Mock functions to simulate contract behavior
function updateGridLoad(region: string, load: number) {
  if (contractOwner !== "owner") throw new Error("Unauthorized")
  const currentData = gridLoad.get(region)
  if (!currentData) throw new Error("Region not found")
  if (load > currentData.capacity) throw new Error("Overcapacity")
  gridLoad.set(region, { ...currentData, currentLoad: load })
  return true
}

function addRegion(region: string, capacity: number) {
  if (contractOwner !== "owner") throw new Error("Unauthorized")
  gridLoad.set(region, { currentLoad: 0, capacity })
  return true
}

function getGridLoad(region: string) {
  return gridLoad.get(region)
}

function setContractOwner(newOwner: string) {
  if (contractOwner !== "owner") throw new Error("Unauthorized")
  contractOwner = newOwner
  return true
}

describe("Grid Management Contract", () => {
  beforeEach(() => {
    gridLoad.clear()
    contractOwner = "owner"
  })
  
  it("should add a new region", () => {
    expect(addRegion("region1", 1000)).toBe(true)
    expect(getGridLoad("region1")).toEqual({ currentLoad: 0, capacity: 1000 })
  })
  
  it("should update grid load", () => {
    addRegion("region1", 1000)
    expect(updateGridLoad("region1", 500)).toBe(true)
    expect(getGridLoad("region1")).toEqual({ currentLoad: 500, capacity: 1000 })
  })
  
  it("should not update load beyond capacity", () => {
    addRegion("region1", 1000)
    expect(() => updateGridLoad("region1", 1500)).toThrow("Overcapacity")
  })
  
  it("should not update non-existent region", () => {
    expect(() => updateGridLoad("region2", 500)).toThrow("Region not found")
  })
  
  it("should change contract owner", () => {
    expect(setContractOwner("newOwner")).toBe(true)
    expect(() => addRegion("region2", 1000)).toThrow("Unauthorized")
  })
})

